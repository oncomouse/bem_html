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
			if(blockNode.attributes["bem-modifiers"])
				nextBlock = [currentBlock]
				JSON.parse(blockNode.attributes["bem-modifiers"].value.gsub(/\:(\w+)/,'"\1"')).each do |modifier|
					nextBlock.push("#{currentBlock}--#{modifier}")
					blockNode['class'] += " #{currentBlock}--#{modifier}"
				end
				blockNode.attributes["bem-modifiers"].remove
			else
				nextBlock = currentBlock
			end
			processingQueue = [blockNode.children]
			while processingQueue.length > 0
				nodes = processingQueue.shift
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
						node['class'] += " #{cb}__#{element}"
					else
						node['class'] += " #{currentBlock}__#{element}"
					end
				
					if(node.attributes["bem-modifiers"])
						JSON.parse(node.attributes["bem-modifiers"].value.gsub(/\:(\w+)/,'"\1"')).each do |modifier|
							if(currentBlock.respond_to? :push)
								currentBlock.each do |cb|
									node['class'] += " #{cb}__#{element}--#{modifier}"
								end
							else
								node['class'] += " #{currentBlock}__#{element}--#{modifier}"
							end
						end
						node.attributes["bem-modifiers"].remove
					end
					node['class'] = node['class'].lstrip
					if(node.children.length > 0)
						processingQueue.push(node.children)
					end
				end
			end
		end
		html_doc.to_s
	end
end