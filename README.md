# Help Desk Ticketing System

A Flutter application for managing help desk tickets using local storage. The project was developed as a technical assessment to demonstrate Clean Architecture, Riverpod state management, and local data persistence with Hive.

---

## Features

* Dashboard with ticket statistics
* Create new tickets
* View ticket details
* Edit ticket information
* Delete tickets with confirmation
* Search tickets by subject
* Filter tickets by status
* Sort tickets by creation date
* Local data persistence using Hive
* Responsive Material 3 interface
* Dark mode toggle with persisted preference
* Export all tickets to JSON
* Ticket history timeline on ticket details

---

## Project Structure

```
lib/
├── app.dart
├── main.dart
├── core/
│   ├── constants/
│   ├── errors/
│   ├── router/
│   ├── services/
│   ├── theme/
│   ├── utils/
│   └── widgets/
└── features/
    └── ticket/
        ├── data/
        │   ├── adapters/
        │   ├── datasources/
        │   ├── mappers/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   └── repositories/
        └── presentation/
            ├── providers/
            ├── router/
            ├── screens/
            ├── state/
            ├── utils/
            └── widgets/
```

---

## Architecture

The project follows a feature-first Clean Architecture approach.

```
Presentation → Repository → Data Source → Hive
```

### Layers

| Layer            | Responsibility                                                    |
| ---------------- | ----------------------------------------------------------------- |
| **Presentation** | Screens, widgets, providers, and user interaction                 |
| **Domain**       | Entities and repository contracts                                 |
| **Data**         | Hive models, data sources, mappers, and repository implementation |

The repository coordinates ticket persistence and ticket number generation, while form validation is handled in the presentation layer. Data sources are responsible only for reading and writing local data.

---

## Packages

* flutter_riverpod
* go_router
* hive
* hive_flutter
* uuid
* path_provider
* hive_generator
* build_runner
* flutter_lints

---

## State Management

Riverpod is used to manage the application state.

The application separates UI from business logic by using providers and controllers for:

* Loading tickets
* Creating tickets
* Updating tickets
* Deleting tickets
* Dashboard statistics
* Theme mode
* JSON export
* Ticket history
* Search
* Filter
* Sort

Search, filtering, and sorting are performed in memory using Riverpod providers to keep the interface responsive without unnecessary reads from local storage.

---

## Local Storage

Hive is used as the local database.

All ticket data is stored locally and remains available after closing and reopening the application.

Hive boxes used:

* `tickets` — ticket records
* `ticket_history` — create/update audit entries
* `app_settings` — ticket counter and theme mode

Ticket numbers are generated using a persistent counter stored in Hive to ensure that every ticket number remains unique, even if previous tickets are deleted.

---

## Running the Project

### Requirements

* Flutter SDK (stable channel)
* Android Studio or VS Code
* Android emulator or physical device

### Commands

```bash
flutter pub get

dart run build_runner build --delete-conflicting-outputs

flutter run

flutter test

flutter analyze
```

---

## Design Decisions

* Hive was chosen because the application only requires local persistence.
* Riverpod was selected to separate state management from the UI.
* A feature-first folder structure keeps related files organized together.
* Ticket numbers are generated using a persistent counter to prevent duplicates.
* Search, filtering, and sorting are handled in memory to reduce unnecessary storage access.
* Reusable widgets are used throughout the application to keep the UI consistent and reduce duplicated code.
* Theme mode is persisted in the settings box and toggled from the dashboard app bar.
* Ticket history is recorded in the repository on create/update and shown on the details screen.
* JSON export writes all tickets to a timestamped file in the app documents directory.

---

## Possible Future Improvements

* CSV export
* More unit and widget tests
* Ticket attachments
* User authentication
* Backend integration with REST APIs
* Cloud synchronization

---

## Assumptions

* The application is designed for a single local user.
* Ticket data is stored only on the device.
* Search is performed using the ticket subject.
* Ticket numbers follow the `TKT-00001` format and are generated sequentially.
* Ticket history is removed when a ticket is deleted.
* The application is intended to work completely without an internet connection.

---

## Screens

* Dashboard
* Ticket List
* Create Ticket
* Ticket Details
