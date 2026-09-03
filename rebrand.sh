#!/bin/sh
# Rebrand Alethio assets in-image for ArbiEver
set -e

HTML=/usr/share/nginx/html
ICON=/tmp/arbiicon.png

# 1. Text replacements in static assets
find "$HTML" -type f \( -name "*.html" -o -name "*.json" -o -name "*.webapp" -o -name "*.js" \) | while read -r f; do
    sed -i \
        -e "s|Ethereum Lite Blockchain Explorer|ArbiEver Lite Explorer|g" \
        -e "s|Ethereum Lite Blockchain|ArbiEver Lite|g" \
        -e "s|Ethereum Lite Explorer|ArbiEver Lite Explorer|g" \
        -e "s|Ethereum blockchain explorer|ArbiEver blockchain explorer|g" \
        -e "s|Ethereum block explorer|ArbiEver block explorer|g" \
        -e "s|Ethereum Lite|ArbiEver Lite|g" \
        -e 's|"ETH"|"ETE"|g' \
        -e "s|'ETH'|'ETE'|g" \
        -e "s|>ETH<|>ETE<|g" \
        "$f" 2>/dev/null || true
done

# 2. Overwrite all favicon / app icon images with arbiicon
for f in $HTML/assets/favicon.ico \
         $HTML/assets/favicon-16x16.png $HTML/assets/favicon-32x32.png \
         $HTML/assets/favicon-96x96.png $HTML/assets/favicon-128.png \
         $HTML/assets/favicon-196x196.png \
         $HTML/assets/apple-touch-icon.png \
         $HTML/assets/apple-touch-icon-precomposed.png \
         $HTML/assets/apple-touch-icon-57x57.png \
         $HTML/assets/apple-touch-icon-60x60.png \
         $HTML/assets/apple-touch-icon-72x72.png \
         $HTML/assets/apple-touch-icon-76x76.png \
         $HTML/assets/apple-touch-icon-114x114.png \
         $HTML/assets/apple-touch-icon-120x120.png \
         $HTML/assets/apple-touch-icon-144x144.png \
         $HTML/assets/apple-touch-icon-152x152.png \
         $HTML/assets/apple-touch-icon-167x167.png \
         $HTML/assets/apple-touch-icon-180x180.png \
         $HTML/assets/apple-touch-icon-1024x1024.png \
         $HTML/assets/android-chrome-36x36.png \
         $HTML/assets/android-chrome-48x48.png \
         $HTML/assets/android-chrome-72x72.png \
         $HTML/assets/android-chrome-96x96.png \
         $HTML/assets/android-chrome-144x144.png \
         $HTML/assets/android-chrome-192x192.png \
         $HTML/assets/android-chrome-256x256.png \
         $HTML/assets/android-chrome-384x384.png \
         $HTML/assets/android-chrome-512x512.png; do
    if [ -f "$f" ]; then cp "$ICON" "$f"; fi
done

# 3. Wrap PNG into SVG to replace the left-menu logo SVG
SVG_FILE=$(find $HTML/img -name "*.svg" 2>/dev/null | head -1)
if [ -n "$SVG_FILE" ]; then
    ARBI_B64=$(base64 "$ICON" | tr -d '\n\r ')
    printf '%s' "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 512 461\"><image href=\"data:image/png;base64,${ARBI_B64}\" width=\"512\" height=\"461\"/></svg>" > "$SVG_FILE"
fi

echo "Rebrand complete"
