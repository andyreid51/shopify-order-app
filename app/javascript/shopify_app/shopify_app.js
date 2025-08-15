import createApp from '@shopify/app-bridge';
import {AppLink, NavigationMenu, Toast} from '@shopify/app-bridge/actions';


document.addEventListener('DOMContentLoaded', () => {
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
  const app = createApp(config);

  const itemsLink = AppLink.create(app, {
    label: 'Items',
    destination: '/items',
  });

  const productsLink = AppLink.create(app, {
    label: 'Products',
    destination: '/',
  });
  
  const settingsLink = AppLink.create(app, {
    label: 'Settings',
    destination: '/settings',
  });
  
  // create NavigationMenu with no active links
  
  const navigationMenu = NavigationMenu.create(app, {
    items: [itemsLink, productsLink, settingsLink],
  });

  //toast test
  const toastOptions = {
    message: 'Product saved',
    duration: 5000
  }

  const toastNotice = Toast.create(app, toastOptions)
  toastNotice.subscribe(Toast.Action.SHOW, data => {
    // Do something with the show action
  })

  toastNotice.subscribe(Toast.Action.CLEAR, data => {
    // Do something with the clear action
  })

  // Dispatch the show Toast action, using the toastOptions above
  toastNotice.dispatch(Toast.Action.SHOW)
  
  
});


