# Class: vision_prometheus::client
# ===========================
#
# Parameters
# ----------
#
# @param exporters List of exporters to include (node exporter is always included)
#
# Examples
# --------
#
# @example
# contain ::vision_prometheus::client
#

class vision_prometheus::client (

  Optional[Array] $exporters = [],

) {

  # Default exporters that should be on every node
  contain vision_prometheus::exporter::node
  contain vision_prometheus::exporter::consul

  # Additional exporters via array
  each ($exporters) | $exporter | {
    contain "vision_prometheus::exporter::${exporter}"
  }

}
