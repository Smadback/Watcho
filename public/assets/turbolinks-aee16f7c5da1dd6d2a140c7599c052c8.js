(function(){var t,e,n,r,o,i,u,a,s,l,c,h,d,p,f,m,v,g,y,w,b,k,E,T,_,H,x,S,L,A,N,O,M,C,X,R,j,D,I,q,F,P,K,$,G,Q,Y,z,B,J=[].indexOf||function(t){for(var e=0,n=this.length;n>e;e++)if(e in this&&this[e]===t)return e;return-1},U={}.hasOwnProperty,V=function(t,e){function n(){this.constructor=t}for(var r in e)U.call(e,r)&&(t[r]=e[r]);return n.prototype=e.prototype,t.prototype=new n,t.__super__=e.prototype,t},W=[].slice;L={},h=10,$=!1,m=null,S=null,X=null,f=null,z=null,w=function(t){var e;return t=new n(t),q(),c(),R(t),$&&(e=G(t.absolute))?(b(e),k(t)):k(t,K)},G=function(t){var e;return e=L[t],e&&!e.transitionCacheDisabled?e:void 0},v=function(t){return null==t&&(t=!0),$=t},k=function(t,e){return null==e&&(e=function(){return function(){}}(this)),Q("page:fetch",{url:t.absolute}),null!=z&&z.abort(),z=new XMLHttpRequest,z.open("GET",t.withoutHashForIE10compatibility(),!0),z.setRequestHeader("Accept","text/html, application/xhtml+xml, application/xml"),z.setRequestHeader("X-XHR-Referer",X),z.onload=function(){var n;return Q("page:receive"),(n=M())?(d.apply(null,y(n)),j(),e(),Q("page:load")):document.location.href=t.absolute},z.onloadend=function(){return z=null},z.onerror=function(){return document.location.href=t.absolute},z.send()},b=function(t){return null!=z&&z.abort(),d(t.title,t.body),C(t),Q("page:restore")},c=function(){var t;return t=new n(m.url),L[t.absolute]={url:t.relative,body:document.body,title:document.title,positionY:window.pageYOffset,positionX:window.pageXOffset,cachedAt:(new Date).getTime(),transitionCacheDisabled:null!=document.querySelector("[data-no-transition-cache]")},p(h)},N=function(t){return null==t&&(t=h),/^[\d]+$/.test(t)?h=parseInt(t):void 0},p=function(t){var e,n,r,o,i,u;for(r=Object.keys(L),e=r.map(function(t){return L[t].cachedAt}).sort(function(t,e){return e-t}),u=[],o=0,i=r.length;i>o;o++)n=r[o],L[n].cachedAt<=e[t]&&(Q("page:expire",L[n]),u.push(delete L[n]));return u},d=function(e,n,r,o){return document.title=e,document.documentElement.replaceChild(n,document.body),null!=r&&t.update(r),o&&g(),m=window.history.state,Q("page:change"),Q("page:update")},g=function(){var t,e,n,r,o,i,u,a,s,l,c,h;for(i=Array.prototype.slice.call(document.body.querySelectorAll('script:not([data-turbolinks-eval="false"])')),u=0,s=i.length;s>u;u++)if(o=i[u],""===(c=o.type)||"text/javascript"===c){for(e=document.createElement("script"),h=o.attributes,a=0,l=h.length;l>a;a++)t=h[a],e.setAttribute(t.name,t.value);e.appendChild(document.createTextNode(o.innerHTML)),r=o.parentNode,n=o.nextSibling,r.removeChild(o),r.insertBefore(e,n)}},F=function(t){return t.innerHTML=t.innerHTML.replace(/<noscript[\S\s]*?<\/noscript>/ig,""),t},R=function(t){return(t=new n(t)).absolute!==X?window.history.pushState({turbolinks:!0,url:t.absolute},"",t.absolute):void 0},j=function(){var t,e;return(t=z.getResponseHeader("X-XHR-Redirected-To"))?(t=new n(t),e=t.hasNoHash()?document.location.hash:"",window.history.replaceState(m,"",t.href+e)):void 0},q=function(){return X=document.location.href},I=function(){return window.history.replaceState({turbolinks:!0,url:document.location.href},"",document.location.href)},D=function(){return m=window.history.state},C=function(t){return window.scrollTo(t.positionX,t.positionY)},K=function(){return document.location.hash?document.location.href=document.location.href:window.scrollTo(0,0)},O=function(t){var e,n;return e=(null!=(n=document.cookie.match(new RegExp(t+"=(\\w+)")))?n[1].toUpperCase():void 0)||"",document.cookie=t+"=; expires=Thu, 01-Jan-70 00:00:01 GMT; path=/",e},Q=function(t,e){var n;return n=document.createEvent("Events"),e&&(n.data=e),n.initEvent(t,!0,!0),document.dispatchEvent(n)},A=function(){return!Q("page:before-change")},M=function(){var t,e,n,r,o,i;return e=function(){var t;return 400<=(t=z.status)&&600>t},i=function(){return z.getResponseHeader("Content-Type").match(/^(?:text\/html|application\/xhtml\+xml|application\/xml)(?:;|$)/)},r=function(t){var e,n,r,o,i;for(o=t.head.childNodes,i=[],n=0,r=o.length;r>n;n++)e=o[n],null!=("function"==typeof e.getAttribute?e.getAttribute("data-turbolinks-track"):void 0)&&i.push(e.getAttribute("src")||e.getAttribute("href"));return i},t=function(t){var e;return S||(S=r(document)),e=r(t),e.length!==S.length||o(e,S).length!==S.length},o=function(t,e){var n,r,o,i,u;for(t.length>e.length&&(i=[e,t],t=i[0],e=i[1]),u=[],r=0,o=t.length;o>r;r++)n=t[r],J.call(e,n)>=0&&u.push(n);return u},!e()&&i()&&(n=f(z.responseText),n&&!t(n))?n:void 0},y=function(e){var n;return n=e.querySelector("title"),[null!=n?n.textContent:void 0,F(e.body),t.get(e).token,"runScripts"]},t={get:function(t){var e;return null==t&&(t=document),{node:e=t.querySelector('meta[name="csrf-token"]'),token:null!=e&&"function"==typeof e.getAttribute?e.getAttribute("content"):void 0}},update:function(t){var e;return e=this.get(),null!=e.token&&null!=t&&e.token!==t?e.node.setAttribute("content",t):void 0}},o=function(){var t,e,n,r,o,i;e=function(t){return(new DOMParser).parseFromString(t,"text/html")},t=function(t){var e;return e=document.implementation.createHTMLDocument(""),e.documentElement.innerHTML=t,e},n=function(t){var e;return e=document.implementation.createHTMLDocument(""),e.open("replace"),e.write(t),e.close(),e};try{if(window.DOMParser)return o=e("<html><body><p>test"),e}catch(u){return r=u,o=t("<html><body><p>test"),t}finally{if(1!==(null!=o&&null!=(i=o.body)?i.childNodes.length:void 0))return n}},n=function(){function t(e){return this.original=null!=e?e:document.location.href,this.original.constructor===t?this.original:void this._parse()}return t.prototype.withoutHash=function(){return this.href.replace(this.hash,"")},t.prototype.withoutHashForIE10compatibility=function(){return this.withoutHash()},t.prototype.hasNoHash=function(){return 0===this.hash.length},t.prototype._parse=function(){var t,e;return(null!=(t=this.link)?t:this.link=document.createElement("a")).href=this.original,e=this.link,this.href=e.href,this.protocol=e.protocol,this.host=e.host,this.hostname=e.hostname,this.port=e.port,this.pathname=e.pathname,this.search=e.search,this.hash=e.hash,this.origin=[this.protocol,"//",this.hostname].join(""),0!==this.port.length&&(this.origin+=":"+this.port),this.relative=[this.pathname,this.search,this.hash].join(""),this.absolute=this.href},t}(),r=function(t){function e(t){return this.link=t,this.link.constructor===e?this.link:(this.original=this.link.href,void e.__super__.constructor.apply(this,arguments))}return V(e,t),e.HTML_EXTENSIONS=["html"],e.allowExtensions=function(){var t,n,r,o;for(n=1<=arguments.length?W.call(arguments,0):[],r=0,o=n.length;o>r;r++)t=n[r],e.HTML_EXTENSIONS.push(t);return e.HTML_EXTENSIONS},e.prototype.shouldIgnore=function(){return this._crossOrigin()||this._anchored()||this._nonHtml()||this._optOut()||this._target()},e.prototype._crossOrigin=function(){return this.origin!==(new n).origin},e.prototype._anchored=function(){var t;return(this.hash&&this.withoutHash())===(t=new n).withoutHash()||this.href===t.href+"#"},e.prototype._nonHtml=function(){return this.pathname.match(/\.[a-z]+$/g)&&!this.pathname.match(new RegExp("\\.(?:"+e.HTML_EXTENSIONS.join("|")+")?$","g"))},e.prototype._optOut=function(){var t,e;for(e=this.link;!t&&e!==document;)t=null!=e.getAttribute("data-no-turbolink"),e=e.parentNode;return t},e.prototype._target=function(){return 0!==this.link.target.length},e}(n),e=function(){function t(t){this.event=t,this.event.defaultPrevented||(this._extractLink(),this._validForTurbolinks()&&(A()||Y(this.link.href),this.event.preventDefault()))}return t.installHandlerLast=function(e){return e.defaultPrevented?void 0:(document.removeEventListener("click",t.handle,!1),document.addEventListener("click",t.handle,!1))},t.handle=function(e){return new t(e)},t.prototype._extractLink=function(){var t;for(t=this.event.target;t.parentNode&&"A"!==t.nodeName;)t=t.parentNode;return"A"===t.nodeName&&0!==t.href.length?this.link=new r(t):void 0},t.prototype._validForTurbolinks=function(){return null!=this.link&&!(this.link.shouldIgnore()||this._nonStandardClick())},t.prototype._nonStandardClick=function(){return this.event.which>1||this.event.metaKey||this.event.ctrlKey||this.event.shiftKey||this.event.altKey},t}(),l=function(t){return setTimeout(t,500)},_=function(){return document.addEventListener("DOMContentLoaded",function(){return Q("page:change"),Q("page:update")},!0)},x=function(){return"undefined"!=typeof jQuery?jQuery(document).on("ajaxSuccess",function(t,e){return jQuery.trim(e.responseText)?Q("page:update"):void 0}):void 0},H=function(t){var e,r;return(null!=(r=t.state)?r.turbolinks:void 0)?(e=L[new n(t.state.url).absolute])?(c(),b(e)):Y(t.target.location.href):void 0},T=function(){return I(),D(),f=o(),document.addEventListener("click",e.installHandlerLast,!0),l(function(){return window.addEventListener("popstate",H,!1)})},E=void 0!==window.history.state||navigator.userAgent.match(/Firefox\/2[6|7]/),a=window.history&&window.history.pushState&&window.history.replaceState&&E,i=!navigator.userAgent.match(/CriOS\//),P="GET"===(B=O("request_method"))||""===B,s=a&&i&&P,u=document.addEventListener&&document.createEvent,u&&(_(),x()),s?(Y=w,T()):Y=function(t){return document.location.href=t},this.Turbolinks={visit:Y,pagesCached:N,enableTransitionCache:v,allowLinkExtensions:r.allowExtensions,supported:s}}).call(this);