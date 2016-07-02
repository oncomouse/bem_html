# bem_html

BEM helpers for HTML.

Utility to convert HTML attributes (`bem-block`, `bem-element`, and `bem-modifiers`) to proper CSS classnames for use in BEM.

## Purpose

In large projects, BEM namespacing can get fairly complicated. In Sass and PostCSS, there exist a number of helper methods to simply the creation of nested Block, Element, Modifier classes; however, this plugin provides similar helper methods within HTML itself.

## Sample Usage

Say you had a BEM block called "widget" that had the following structure in HTML:

~~~html

<div class="widget">
	<h1 class="widget__heading widget__heading--lime">Heading</h1>
	<section class="widget__content">
		<p class="widget__content__first-paragraph">First Paragraph</p>
	</section>
</div>
~~~

With bem-html, you could define that structure instead as the following:

~~~html
<div bem-block="widget">
	<h1 bem-element="heading" modifiers="[:lime]">Heading</h1>
	<section bem-element="content">
		<p bem-element="first-paragraph">First Paragraph</p>
	</section>
</div>
~~~

And this extension would produce the desired HTML.

Originally, this extension was specifically designed for HAML, where it really shines:

~~~haml
%div{bem:{block: :widget}}
	%h1{bem:{element: :heading, modifiers: [:lime]}} Heading
	%section{bem:{element: :content}}
		%p{bem: {element: "first-paragraph"}} First Paragraph
~~~

## Installation

Install using `gem bem_html`

## Usage

Sample Ruby code:

~~~ ruby
require "bem_html"

html = IO.read("index.html")
BemHtml.parse(html) # -> Will output index.html with bem-* tags converted to CSS names
~~~

## Todo

* Binary parser for CLI usage