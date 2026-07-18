# 🎌 Otaku Inventory System

A cloud-native **SAP RAP (RESTful Application Programming Model)** application built on **SAP BTP ABAP Environment** for managing anime collections, tracking market demand, and generating customized reports. The project demonstrates modern SAP development using ABAP Cloud, CDS View Entities, Behavior Definitions, and SAP Fiori Elements.

---

## 📖 Overview

The **Otaku Inventory System** is an enterprise-grade inventory management application designed for anime enthusiasts and collectors. It enables users to manage anime inventory, maintain ratings and character information, monitor market demand, and generate exportable reports through an intuitive SAP Fiori interface.

The application is developed using the **SAP RAP framework** and follows SAP's cloud development best practices, ensuring scalability, maintainability, and clean architecture.

---

## ✨ Features

- 📚 Manage Anime Inventory
- ⭐ Store and maintain Anime Ratings
- 👥 Maintain Character Profiles
- 📈 Market Demand Progress Indicator
- 🚦 Criticality-based Demand Visualization
- 📄 Generate TXT Report for Anime Records
- 🔗 Association-based Data Navigation
- 📱 Responsive SAP Fiori Elements UI
- ☁️ Cloud-ready SAP RAP Application

---

## 🏗️ System Architecture

```
SAP BTP (ABAP Cloud)
        │
        ▼
 CDS View Entities
        │
        ▼
 Behavior Definitions
 (Managed & Unmanaged RAP)
        │
        ▼
 OData Service
        │
        ▼
 SAP Fiori Elements UI
```

---

## 🛠️ Technology Stack

| Technology | Description |
|------------|-------------|
| SAP BTP | Cloud Development Platform |
| ABAP Cloud | Modern ABAP Development |
| SAP RAP | RESTful Application Programming Model |
| SAP Fiori Elements | Responsive User Interface |
| CDS View Entities | Data Modeling |
| Metadata Extensions | UI Customization |
| Behavior Definitions | Business Logic |
| OData V4 | Service Exposure |
| Eclipse ADT | Development Environment |

---

## 📂 Project Structure

```
Otaku-Inventory-System
│
├── CDS View Entities
│   ├── Root View
│   ├── Interface Views
│   ├── Projection Views
│
├── Behavior Definitions
│   ├── Managed Scenario
│   ├── Unmanaged Scenario
│
├── Behavior Implementation
│
├── Metadata Extensions
│
├── Service Definition
│
├── Service Binding
│
├── Authorization (DCL)
│
├── SAP Fiori Elements App
│
└── README.md
```

---

## 🚀 Key Functionalities

### 📚 Anime Inventory Management

- Create Anime Records
- Update Anime Information
- Delete Anime Records
- Search and Filter Anime

---

### ⭐ User Rating Management

- Maintain Anime Ratings
- Rating History
- Average Rating Calculation

---

### 👥 Character Management

- Associate Characters with Anime
- Maintain Character Details
- Display Character Information

---

### 📈 Market Demand Analysis

- Demand Percentage Indicator
- Dynamic Progress Bar
- Criticality Coloring
- Popularity Visualization

---

### 📄 TXT Report Generation

The application provides an inline RAP Action named:

```
Generate Text
```

This feature exports the selected Anime record into a structured TXT format for reporting and archival purposes.

---

## 🧩 RAP Features Implemented

- Managed RAP
- Unmanaged RAP
- Behavior Definitions
- Determinations
- Validations
- Actions
- Associations
- Draft Handling
- CRUD Operations
- OData V4 Services

---

## 🎨 SAP Fiori Features

- List Report
- Object Page
- Header Facets
- Field Groups
- Line Items
- Identification Sections
- Dynamic Criticality
- Progress Indicators
- Responsive Layout

---



---

## 🔥 Highlights

- Modern SAP RAP Architecture
- Cloud-Native Development
- Clean CDS Modeling
- Association-Based Design
- Interactive SAP Fiori UI
- Market Demand Analytics
- TXT Report Generation
- Enterprise-Level Business Logic

---



---



## 👨‍💻 Author

**Deebak G R**

SAP ABAP | SAP RAP | SAP BTP | ABAP Cloud Developer

---

