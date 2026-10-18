import QtQuick
import qs.Commons as Commons

Item {
  id: root

  // Services inherit shell.qml's context. Keep the original bar and its widgets.
  readonly property var bar: shell.bar

  function lockBar() {
    if (!bar) return
    bar.setRequestedTransparency(false)
    bar.background = Qt.binding(function() {
      var color = Commons.Color.bar.background
      return Qt.rgba(color.r, color.g, color.b, 1)
    })
  }

  function saveOpaqueConfig() {
    if (shell.shellConfig.bar?.transparent !== true) return
    shell.mutateShellConfig(function(config) { config.bar.transparent = false })
  }

  onBarChanged: lockBar()

  Connections {
    target: root.bar

    function onRequestedTransparentChanged() {
      if (root.bar.requestedTransparent) root.bar.setRequestedTransparency(false)
    }
  }

  Connections {
    target: shell

    // Wait for the current config write to finish before persisting the lock.
    function onShellConfigChanged() { Qt.callLater(root.saveOpaqueConfig) }
  }

  Component.onCompleted: {
    lockBar()
    saveOpaqueConfig()
  }
}
