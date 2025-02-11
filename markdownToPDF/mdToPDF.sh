# Copyright (c) 2019 3MF Consortium
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#!/bin/bash

# mkdir ~/.grip
# echo "PASSWORD = '${GITHUB_API_KEY}'" > ~/.grip/settings.py

FILE="$1"
TMPFILE="temp.html"

/home/runner/.local/bin/grip "$FILE.md" --export "$FILE.html"
sed "s|readme boxed-group clearfix announce instapaper_body md||g" "$FILE.html" > "$TMPFILE"
sed -i "s|.md$||g" "$TMPFILE"
sed -i 's|<a href="images/3mf_logo_50px.png"|<a|g' "$TMPFILE"

sed -i 's|<a href="#|<a href="@|g' "$TMPFILE"
sed -i 's|href="#|name="|g' "$TMPFILE"
sed -i 's|<a href="@|<a href="#|g' "$TMPFILE"
sed -i 's|<pre|<code style="white-space: pre-wrap; page-break-inside: avoid !important; display: block;"|g' "$TMPFILE"
sed -i 's|</pre|</code|g' "$TMPFILE"
sed -i "/Page tweaks/ a 	* {		font-size: large;	}" "$TMPFILE"
sed -i 's|margin-top: 64px;|margin-top: 64px; margin-right: 21px;|g' "$TMPFILE"
sed -i 's|margin-bottom: 21px;|margin-bottom: 21px; margin-left: 21px;|g' "$TMPFILE"

MARGIN=14

./wkhtmltopdf --title "$FILE" --footer-left "[section]" --footer-right "[page]/[topage]" --footer-font-size 7 --footer-spacing 4 \
--margin-top $MARGIN --margin-left $MARGIN --margin-right $MARGIN --margin-bottom $MARGIN \
"$TMPFILE" "$FILE.pdf"
