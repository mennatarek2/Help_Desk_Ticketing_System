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
## Screens

<table>
  <tr>
    <th>Light Mode</th>
    <th>Dark Mode</th>
  </tr>
  <tr>
    <td align="center"><b>Dashboard</b></td>
    <td align="center"><b>Dashboard</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_2026-08-02_17-59-49" src="https://github.com/user-attachments/assets/b364e4f3-1fa0-49da-bb1e-92cb4edeb02b" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_17_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/9e5235d8-a439-47ae-94c2-a47324159317" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Tickets List</b></td>
    <td align="center"><b>Tickets List</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_10_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/cff62abd-0a22-47ab-b449-577a0b211bdd" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_19_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/b56d08ed-6814-44d1-b9c0-9ade0ca855cf" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Filter — Open</b></td>
    <td align="center"><b>Filter — Open</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_7_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/292e0008-4591-42b0-a01b-da22982aee25" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_20_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/d86e98bd-c00c-43e4-ad2e-cd8a692c037f" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Filter — In Progress</b></td>
    <td align="center"><b>Filter — In Progress</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_8_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/14ede61f-ff2a-4f32-9751-433c43a869a1" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_21_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/13fa8b7b-0825-44a0-9b60-9681afeaac01" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Filter — Closed</b></td>
    <td align="center"><b>Filter — Closed</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_9_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/fa30e00e-a4ec-40f5-bf4b-11ba396df3e8" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_22_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/64241776-c1b3-4dfd-af59-df75e90feec3" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Ticket Details</b></td>
    <td align="center"><b>Ticket Details</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_15_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/e72b3ebe-d314-4e9d-a144-9ee1da032244" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_24_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/18ae6c2e-3c79-4f1c-8817-b0e7c1f76246" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Search</b></td>
    <td align="center"><b>Search</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_12_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/0bf87cd2-3acc-4dc7-b635-bda166fc153e" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_2026-08-02_18-20-55" src="https://github.com/user-attachments/assets/22151718-f929-4c30-9c71-37dd5a74d284" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Create Ticket</b></td>
    <td align="center"><b>Create Ticket</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_2_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/06af649b-2363-4295-8648-d759d4878585" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_27_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/8def0d76-084a-4a7f-8842-e5bfb1898b42" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Delete Ticket</b></td>
    <td align="center"><b>Delete Ticket</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_5_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/100bc63d-eae7-4bd5-be00-be4be5ede583" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_25_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/df6ada8e-a7c6-44e3-b790-c02bdaba62c4" />
 width="260"/></td>
  </tr>
  <tr>
    <td align="center"><b>Edit Ticket — Status</b></td>
    <td align="center"><b>Empty State</b></td>
  </tr>
  <tr>
    <td><img width="576" height="1280" alt="photo_3_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/efa44969-0925-4f04-b488-c24ca327c59d" />
 width="260"/></td>
    <td><img width="576" height="1280" alt="photo_1_2026-08-02_17-58-07" src="https://github.com/user-attachments/assets/c47431fc-c2c2-4163-b8bc-c1678fd27b09" />
 width="260"/></td>
  </tr>
</table>![Uploading photo_17_2026-08-02_17-58-07.jpg…]()

