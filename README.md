Perfect 👍 — here’s your **README.md** content and **Template Gallery metadata** (like what appears in the GTM Template Gallery page).
This is professional, concise, and explains your variable template’s purpose clearly for other developers and marketers 👇

---

### **README.md**

# 🧩 Customer Lifetime Value (CLV) Lookup – Server-Side GTM Variable

**Author:** [Alif Mahmud](https://alifmahmud.com)
**Version:** 1.0.0
**Category:** Variable Template
**Compatible with:** Server-Side Google Tag Manager (sGTM)
**Initial Publish:** November 2025

---

## 📘 Overview

The **Customer Lifetime Value (CLV) Lookup** variable helps you retrieve and calculate total purchase value and customer status (new or returning) directly from your **Stape Store** within **Server-Side Google Tag Manager**.

It’s designed for advertisers who want to use **Google Ads’ “Provide New Customer Data”** parameter and need accurate, server-based CLV and user type data — without depending on unreliable browser-side methods or cookies.

---

## ⚙️ Key Features

✅ Retrieve customer purchase data from **Stape Store**
✅ Calculate **Customer Lifetime Value (CLV)** securely on the server
✅ Identify **New vs. Returning customers**
✅ Filter execution by specific events (e.g. `purchase`)
✅ Works with **any eCommerce platform** or CRM that sends event data to sGTM

---

## 🚀 Use Cases

* Send accurate CLV and customer-type data to **Google Ads Conversion Tracking**
* Enable **Provide New Customer Data** for improved audience segmentation
* Track **customer value-based conversions** across sessions and devices
* Build your own **server-side customer value storage** system

---

## 🧠 How It Works

1. The variable reads a **user document** from your connected **Stape Store** (based on email or unique ID).
2. It calculates the **sum of all past transaction values (CLV)**.
3. If there’s only one transaction record, it flags the user as **new**; otherwise, as **returning**.
4. You can limit execution to specific events using the **Event Allow Pattern** field.

---

## 🧩 Fields

| Field                        | Description                                                                |
| ---------------------------- | -------------------------------------------------------------------------- |
| **mode**                     | Output mode: `"clv"` (returns numeric CLV) or `"is_new"` (returns boolean) |
| **documentKey**              | Customer identifier (usually email)                                        |
| **stapeStoreCollectionName** | Collection name in your Stape Store                                        |
| **eventAllowPattern**        | Comma or pipe-separated event names to restrict execution                  |

---

## 🔒 Requirements

* Active **Stape Store** setup connected to your sGTM container
* Server-Side Google Tag Manager environment
* Proper permissions for `sendHttpRequest`, `JSON`, and request headers

---

## 🌐 Author

**Developed by:** [Alif Mahmud](https://alifmahmud.com)
**Website:** [https://alifmahmud.com](https://alifmahmud.com)
**Expertise:** Google Tag Manager, GA4, Server-Side Tracking, Conversion APIs

