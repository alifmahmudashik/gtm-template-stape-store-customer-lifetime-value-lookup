___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Stape Store - Customer Lifetime Value Lookup",
  "description": "Fetches user purchase history from Stape Store to calculate total customer lifetime value and identify established vs new customers based on past transactions.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "eventAllowPattern",
    "displayName": "Event Name",
    "simpleValueType": true,
    "help": "“Optional. Comma or | separated list. Example: purchase|refund or purchase,begin_checkout.”"
  },
  {
    "type": "SELECT",
    "name": "mode",
    "displayName": "Output Mode",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "is_new",
        "displayValue": "Is New Customer?"
      },
      {
        "value": "clv",
        "displayValue": "Customer Lifetime Value"
      }
    ],
    "simpleValueType": true,
    "help": "Is New? → returns true if no prior purchases exist for this email.  Customer Lifetime Value → returns the numeric sum of all values stored in Stape Store for the document."
  },
  {
    "type": "TEXT",
    "name": "documentKey",
    "displayName": "Document Key (Email)",
    "simpleValueType": true,
    "help": "Must match the key you use when writing purchases (e.g., info@alifmahmud.com)."
  },
  {
    "type": "TEXT",
    "name": "stapeStoreCollectionName",
    "displayName": "Collection Name",
    "simpleValueType": true,
    "defaultValue": "default",
    "help": "Stape Store collection that holds documents. If you didn’t change collections in your writer, leave as default."
  }
]


___SANDBOXED_JS_FOR_SERVER___

/// <reference path="./server-gtm-sandboxed-apis.d.ts" />

var JSON = require('JSON');
var sendHttpRequest = require('sendHttpRequest');
var getRequestHeader = require('getRequestHeader');
var encodeUriComponent = require('encodeUriComponent');
var makeString = require('makeString');
var makeNumber = require('makeNumber');
var getEventData = require('getEventData');

var mode        = makeString(data.mode || 'clv'); // 'clv' | 'is_new'
var documentKey = makeString(data.documentKey || '');
var collection  = makeString(data.stapeStoreCollectionName || 'default');
var eventAllowPattern = makeString(data.eventAllowPattern || '');

// ---- Event-based gating ----
var ev = makeString(
  getEventData('event_name') ||
  getEventData('_event')     ||
  getEventData('event')      ||
  ''
);

if (eventAllowPattern) {
  var allowed = false;
  var norm = eventAllowPattern.split('|').join(',');
  var parts = norm.split(',');
  for (var i = 0; i < parts.length; i++) {
    var p = makeString(parts[i] || '').trim();
    if (!p) continue;
    if (ev === p || (ev && ev.indexOf(p) !== -1)) {
      allowed = true;
      break;
    }
  }
  if (!allowed) return undefined; // Only run for allowed events
}

// ---- Build Stape Store URL ----
var cid = makeString(getRequestHeader('x-gtm-identifier') || '');
var dom = makeString(getRequestHeader('x-gtm-default-domain') || '');
var api = makeString(getRequestHeader('x-gtm-api-key') || '');

if (!cid || !dom || !api || !documentKey) {
  return (mode === 'is_new') ? true : 0; // Fallback
}

var url =
  'https://' + enc(cid) + '.' + enc(dom) +
  '/stape-api/' + enc(api) +
  '/v2/store/collections/' + enc(collection) +
  '/documents/' + enc(documentKey);

// ---- Fetch and process ----
return sendHttpRequest(url, { method: 'GET' }).then(function (resp) {
  var bodyStr = makeString(resp.body || '');
  var looksJson = bodyStr.length && bodyStr.charAt(0) === '{' && bodyStr.charAt(bodyStr.length - 1) === '}';
  var body = looksJson ? JSON.parse(bodyStr) : {};

  if (resp.statusCode === 404) return (mode === 'is_new') ? true : 0;
  if (resp.statusCode !== 200) return (mode === 'is_new') ? true : 0;

  var store = (body && body.data && body.data.data) ? body.data.data : {};
  var txnCount = 0;
  var total = 0;

  for (var k in store) {
    if (!k) continue;
    txnCount++;
    var n = makeNumber(store[k]);
    if (n) total += n;
  }

  // ---- Logic ----
  if (mode === 'is_new') {
    // 0 or 1 transaction ID = new user
    return txnCount <= 1;
  }
  // CLV = total value sum
  return total;
});

/* helper */
function enc(x) {
  return encodeUriComponent(makeString(x || ''));
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 05/11/2025, 15:56:17


