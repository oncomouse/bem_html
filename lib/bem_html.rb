require 'json'
require 'nokogiri'

class BemHtml
	def self.parse(content)
		html_doc = Nokogiri::HTML(content)
		html_doc.xpath('.//*[@bem-block]|*[@bem-block]').each do |blockNode|
			currentBlock = blockNode["bem-block"]
			blockNode.attributes["bem-block"].remove
			if(not blockNode['class'])
				blockNode['class'] = ""
			end
			blockNode['class'] += " #{currentBlock}"
			nextBlock = [currentBlock]
			if(blockNode.attributes["bem-modifiers"])
				JSON.parse(blockNode.attributes["bem-modifiers"].value.gsub(/\:(\w+)/,'"\1"')).each do |modifier|
					nextBlock.push("#{currentBlock}--#{modifier}")
					blockNode['class'] += " #{currentBlock}--#{modifier}"
				end
				blockNode.attributes["bem-modifiers"].remove
			end
			processingQueue = [[nextBlock, blockNode.children]]
			while processingQueue.length > 0
				topQueue = processingQueue.shift
				currentBlock = topQueue[0]
				nodes = topQueue[1]
				nodes.each do |node|
					next if not node.attributes
					next if node.attributes["bem-block"]
					next if not node.attributes["bem-element"]
				
					if(not node['class'])
						node['class'] = ""
					end
				
					element = node.attributes["bem-element"]
					node.attributes["bem-element"].remove
					if(currentBlock.respond_to? :push)
						nextBlock = currentBlock.map do |cb|
							node['class'] += " #{cb}__#{element}"
							"#{cb}__#{element}"
						end
					else
						nextBlock = "#{currentBlock}__#{element}"
						node['class'] += " #{nextBlock}"
					end
				
					if(node.attributes["bem-modifiers"])
						JSON.parse(node.attributes["bem-modifiers"].value.gsub(/\:(\w+)/,'"\1"')).each do |modifier|
							if(currentBlock.respond_to? :push)
								currentBlock.each do |cb|
									node['class'] += " #{cb}__#{element}--#{modifier}"
									nextBlock.push("#{cb}__#{element}--#{modifier}")
								end
							else
								node['class'] += " #{currentBlock}__#{element}--#{modifier}"
							end
						end
						node.attributes["bem-modifiers"].remove
					end
					if(node.children.length > 0)
						processingQueue.push([nextBlock, node.children])
					end
				end
			end
		end
		html_doc.to_s
	end
end