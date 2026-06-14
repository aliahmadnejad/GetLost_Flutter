# GetLost! — Mobile App

> *Spontaneous travel, instant beds.*

GetLost! is a Flutter mobile application for backpackers who want to travel on a whim. Hostels leave a portion of beds available for same-day reservations — GetLost! connects those beds with travelers the moment they land.

---

## What It Does

Traveling without a plan is exciting, but finding a bed the day you arrive is stressful. GetLost! solves that by surfacing hostels that offer same-day availability, letting users reserve instantly and connect with the people staying there.

**Key Features**

- **Browse same-day availability** — see hostels with open beds in real time
- **Instant reservation** — book a bed with one tap via Stripe
- **Hostel group chat** — every reservation puts you in a live chat with fellow guests at that hostel, so you can coordinate, share tips, and find travel companions before you even arrive
- **Safe travel** — the group chat keeps guests connected and looking out for each other

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter / Dart |
| Payments | Stripe SDK |
| Real-time Chat | WebSockets / Firebase |
| Backend | Django REST API → [GetLost_Django](https://github.com/aliahmadnejad/GetLost_Django) |

---

## Related Repositories

- 📱 **This repo** — Flutter mobile client
- ⚙️ [GetLost_Django](https://github.com/aliahmadnejad/GetLost_Django) — Django REST API backend

---

## Getting Started

```bash
# Clone the repo
git clone https://github.com/aliahmadnejad/GetLost_Flutter.git
cd GetLost_Flutter/getLost_app

# Install Flutter dependencies
flutter pub get

# Run the app
flutter run
```

Make sure you have Flutter installed and a device/emulator running. The app connects to the Django backend — see [GetLost_Django](https://github.com/aliahmadnejad/GetLost_Django) for backend setup.

---

## Screenshots

*Coming soon*

---

## Author

**Ali Ahmadnejad** · [Portfolio](https://aliahmadnejad.github.io) · [GitHub](https://github.com/aliahmadnejad)
