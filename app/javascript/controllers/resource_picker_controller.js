import { Controller } from "@hotwired/stimulus"
import { createApp } from "@shopify/app-bridge";
import { ResourcePicker } from "@shopify/app-bridge/actions";

// Connects to data-controller="resource-picker"
export default class extends Controller {
  static targets = ["output"]; // Example target to display selected resources

  connect() {
    const shopifyAppInit = document.getElementById('shopify-app-init')
    if (!shopifyAppInit) { return }
    var data = shopifyAppInit.dataset;
    if (data.forceIframe === "false") { return }

    const config = {
      // The client ID provided for your application in the Partner Dashboard.
      apiKey: data.apiKey,
      // The host of the specific shop that's embedding your app. This value is provided by Shopify as a URL query parameter that's appended to your application URL when your app is loaded inside the Shopify admin.
      host: data.host,
      forceRedirect: true
    };
    this.app = createApp(config);
  }

  openPicker() {
    const resourcePicker = ResourcePicker.create(this.app, {
      resourceType: ResourcePicker.ResourceType.Product,
      options: {
        selectMultiple: true,
      },
    });

    resourcePicker.dispatch(ResourcePicker.Action.OPEN);

    console.log("picker click")
  }
}
