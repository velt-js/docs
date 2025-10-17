// Signals tracking script
(function() {
    if (typeof window === 'undefined') return;
    if (typeof window.signals !== 'undefined') return;
    var script = document.createElement('script');
    script.src = 'https://cdn.cr-relay.com/v1/site/08f69d8a-754c-4c96-a7de-bef17fb066e1/signals.js';
    script.async = true;
    window.signals = Object.assign(
      [],
      ['page', 'identify', 'form'].reduce(function (acc, method){
        acc[method] = function () {
          signals.push([method, arguments]);
          return signals;
        };
       return acc;
      }, {})
    );
    document.head.appendChild(script);
})();

