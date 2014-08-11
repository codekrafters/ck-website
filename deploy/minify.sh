#!/bin/bash

echo "Minifying JS using Closure Compiler"
java -jar deploy/tools/compiler.jar --js js/theme.js --js_output_file js-min/theme.js
java -jar deploy/tools/compiler.jar --js js/packages.js --js_output_file js-min/packages.js

echo ""
echo "Minifying CSS using YUICompressor"
java -jar deploy/tools/yuicompressor-2.4.8.jar --type css -o css-min/theme.css css/theme.css
java -jar deploy/tools/yuicompressor-2.4.8.jar --type css -o css-min/ck.css css/ck.css
java -jar deploy/tools/yuicompressor-2.4.8.jar --type css -o css-min/ck-mobile.css css/ck-mobile.css
java -jar deploy/tools/yuicompressor-2.4.8.jar --type css -o css-min/color-defaults-fonts.css css/color-defaults-fonts.css
java -jar deploy/tools/yuicompressor-2.4.8.jar --type css -o css-min/swatch-dark-white.css css/swatch-dark-white.css
java -jar deploy/tools/yuicompressor-2.4.8.jar --type css -o css-min/swatch-red-white.css css/swatch-red-white.css
java -jar deploy/tools/yuicompressor-2.4.8.jar --type css -o css-min/swatch-white-red.css css/swatch-white-red.css

echo ""
echo "Checking CSS href in index.html file"
CSS_CHECK=$(grep -i "href=\"css/" index.html | grep -v "animate.css")

if [ ! -z "$CSS_CHECK" ]; then
	echo ""
	echo "Some href links in your index.html are not pointing to minified CSS"
	echo "$CSS_CHECK"
else
	echo "All href links are pointing to minified CSS"
fi
echo ""

echo ""
echo "Checking JS href in index.html file"
JS_CHECK=$(grep -i "src=\"js/" index.html)

if [ ! -z "$JS_CHECK" ]; then
	echo ""
	echo "Some href links in your index.html are not pointing to minified JS"
	echo "$JS_CHECK"
else
	echo "All href links are pointing to minified JS"
fi
echo ""
fi
