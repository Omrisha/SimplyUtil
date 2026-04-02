---
layout: default
title: SimplyUtil - Privacy & Security
---

# SimplyUtil
**Your Travel Companion**

*Last Updated: April 2, 2026*

---

## 🔒 Privacy Policy

SimplyUtil is committed to protecting your privacy. This policy explains what data we collect, how we use it, and your rights regarding your information.

### Information We Collect

> **TL;DR:** We only collect the minimal information needed to provide our services. Your favorite cities are stored locally on your device, and we don't track your personal information.

#### Data Stored Locally on Your Device

- **Favorite Cities:** Cities you mark as favorites are stored locally on your device using SwiftData. This data never leaves your device unless you explicitly back it up through iCloud (controlled by your iOS settings).
- **No Personal Information:** We do not collect names, email addresses, phone numbers, or any personally identifiable information.

#### Data Requested from Our Servers

- **City Information:** When you browse cities, we fetch data from our backend server including city names, countries, and currency codes.
- **Weather Forecasts:** We retrieve weather data for cities you select to view.
- **Landmarks:** Location data for landmarks and points of interest in cities you're exploring.
- **Exchange Rates:** Current currency exchange rates for travel planning.

#### Server Logs

Our backend server may log basic technical information for debugging and service improvement, including:

- Anonymized request timestamps
- API endpoint accessed
- HTTP status codes

These logs do not contain personally identifiable information and are automatically deleted after 30 days.

### What We DON'T Collect

- ❌ Your precise location (we don't use GPS tracking)
- ❌ Personal information (name, email, phone number)
- ❌ Usage analytics or tracking cookies
- ❌ Advertising identifiers
- ❌ Social media data
- ❌ Payment information (the app is free)

### Third-Party Services

SimplyUtil retrieves data from our own backend server hosted at `app-quiet-rain-433.fly.dev`. This server aggregates data from:

- **Weather Data:** From public weather APIs
- **Exchange Rates:** From public financial data sources
- **Landmark Information:** From public mapping services

These services are accessed server-side, meaning your device does not directly communicate with them. Your queries are anonymized.

### Data Sharing

**We do not sell, trade, or share your data with third parties.** Your favorite cities remain private and stored only on your device.

### iCloud Sync (Optional)

If you have iCloud enabled on your device, your favorite cities may sync across your Apple devices through iCloud. This is controlled entirely by your iOS settings, and we do not have access to this data. Please review Apple's [Privacy Policy](https://www.apple.com/legal/privacy/) for more information about iCloud.

### Children's Privacy

SimplyUtil does not knowingly collect information from children under 13. The app is designed for general audiences and does not contain age-restricted content.

### Your Rights

You have the right to:

- Delete all your favorite cities at any time from within the app
- Stop using the app and remove it from your device
- Contact us with questions about your privacy

### Changes to This Policy

We may update this privacy policy from time to time. We will notify you of any significant changes by updating the "Last Updated" date at the top of this page. Continued use of the app after changes constitutes acceptance of the updated policy.

---

## 🛡️ Security

### How We Protect Your Data

#### 🔐 HTTPS Encryption
All communication between the app and our servers uses HTTPS encryption to protect data in transit.

#### 📱 Local Storage
Your favorites are stored locally using SwiftData, protected by your device's built-in encryption.

#### 🚫 No Authentication
Since we don't collect personal data, there's no password or account to protect or compromise.

#### 🔄 Minimal Data Transfer
We only request the specific data you need, when you need it, minimizing exposure.

### Open Source

SimplyUtil is open source! You can review our code on [GitHub](https://github.com/omrisha) to verify our privacy and security practices.

### Reporting Security Issues

If you discover a security vulnerability, please report it responsibly by creating an issue on our GitHub repository or contacting the developer directly. We take security seriously and will respond promptly to reports.

---

## 📞 Contact

If you have questions or concerns about this privacy policy or the app's security practices, please contact:

- **GitHub:** [@omrisha](https://github.com/omrisha)
- **Project Repository:** [github.com/omrisha/simplyutil](https://github.com/omrisha/simplyutil)

---

## 📋 Data Summary

| Data Type | Storage Location | Purpose |
|-----------|-----------------|---------|
| Favorite Cities | Your Device (SwiftData) | Save your preferred destinations |
| Weather Data | Fetched on demand | Display current forecasts |
| Exchange Rates | Fetched on demand | Currency conversion |
| Landmarks | Fetched on demand | Show points of interest |
| Server Logs | Backend (30 days) | Service monitoring |

---

<div align="center">

**SimplyUtil** is created by [Omri Shapira](https://github.com/omrisha)

Built with ❤️ using SwiftUI and SwiftData

© 2026 SimplyUtil. All rights reserved.

</div>
