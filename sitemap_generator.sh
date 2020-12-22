#!/bin/sh

shopt -s globstar

echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
cd public
for FILE in **/*.html
do
  echo "  <url>"
  echo "    <loc> $DOMAIN/$FILE </loc>"
  echo "    <lastmod> $(stat -c '%y' "$FILE") </lastmod>"
  echo "    <changefreq> monthly </changefreq>"
  DEPTH="$(echo "$FILE" | tr -cd '/' | wc -c )"
  # weigh page priority inversely by depth
  echo "    <priority> $( echo "2^-$DEPTH" | bc -l ) </priority>"
  echo "  </url>"
done
echo "</urlset>"
