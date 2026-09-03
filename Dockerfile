FROM alethio/ethereum-lite-explorer:latest

COPY arbiicon512.png /tmp/arbiicon.png
COPY rebrand.sh /tmp/rebrand.sh

RUN sh /tmp/rebrand.sh && rm /tmp/rebrand.sh /tmp/arbiicon.png
