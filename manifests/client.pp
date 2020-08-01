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

  contain vision_prometheus::exporter::node

  each ($exporters) | $exporter | {
    contain "vision_prometheus::exporter::${exporter}"
  }

}
