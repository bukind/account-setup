#!/bin/bash
#
# Deny/Allow special user all outgoing IPv4 traffic.
# Usage:
#  restrict-kid.sh allow [kid]
#  restrict-kid.sh deny [kid]
#
# A kid can be selected by setting KID envvar.

if [ -z "$2" ]; then
  echo "Usage: $0 (allow|deny) KID" >&2
  exit 1
fi

KID=${2}

if ! (/bin/id "${KID}" >&/dev/null); then
  echo "No such user '${KID}'!" >&2
  exit 1
fi

CHAIN="restrict-${KID}"

# Create a chain if it does not exist yet.
if ! ( /usr/bin/firewall-cmd --direct --get-all-chains | grep -q ${CHAIN} ); then
  echo "Making a ${CHAIN}"
  /usr/bin/firewall-cmd --direct --add-chain ipv4 filter ${CHAIN}
  /usr/bin/firewall-cmd --direct --add-rule ipv4 filter OUTPUT 100 -m owner --uid-owner ${KID} -j ${CHAIN}
  /usr/bin/firewall-cmd --direct --add-chain ipv6 filter ${CHAIN}
  /usr/bin/firewall-cmd --direct --add-rule ipv6 filter OUTPUT 100 -m owner --uid-owner ${KID} -j ${CHAIN}
fi

case "$1" in
("deny")
  /usr/bin/firewall-cmd --direct --remove-rules ipv4 filter ${CHAIN}
  /usr/bin/firewall-cmd --direct --add-rule ipv4 filter ${CHAIN} 100 -j DROP
  /usr/bin/firewall-cmd --direct --remove-rules ipv6 filter ${CHAIN}
  /usr/bin/firewall-cmd --direct --add-rule ipv6 filter ${CHAIN} 100 -j DROP
  ;;
("allow")
  /usr/bin/firewall-cmd --direct --remove-rules ipv4 filter ${CHAIN}
  /usr/bin/firewall-cmd --direct --remove-rules ipv6 filter ${CHAIN}
  ;;
(*)
  /usr/bin/firewall-cmd --direct --get-all-rules
  ;;
esac
