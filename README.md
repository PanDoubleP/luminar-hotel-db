Luminar Boutique Hotel — Relational Database Design & Implementation

A fully normalized relational database for a hotel reservation and management system, designed and implemented as part of **ITCS442: Relational Database Design** at the Faculty of Information and Communication Technology, Mahidol University (Semester 2/2025).

---

## Project Overview

This project models the complete data lifecycle of a boutique hotel operation — from guest registration and room booking to payment processing and staff management. The database was designed from scratch through all phases: conceptual modeling (ER Diagram), logical mapping (Relational Schema), normalization (1NF–3NF), and physical implementation in MySQL.

---

## Database Schema

The database `LuminarBoutique` contains **16 tables** organized around the following domains:

### Guest & Staff
| Table | Description |
|---|---|
| `Guest` | Core guest profiles with identification and nationality |
| `GuestPhoneNumber` | Multi-valued phone numbers per guest |
| `GuestEmail` | Multi-valued email addresses per guest |
| `Staff` | Hotel staff with roles |
| `StaffPhoneNumber` | Multi-valued phone numbers per staff |
| `StaffEmail` | Multi-valued email addresses per staff |

### Rooms
| Table | Description |
|---|---|
| `RoomType` | Room categories (Standard, Deluxe, Family, Suite) with pricing |
| `Room` | Individual rooms with status (`Available`, `Occupied`, `Maintenance`) |

### Bookings
| Table | Description |
|---|---|
| `Booking` | Booking records linking guest, staff, and booking source |
| `BookingRoom` | Junction table resolving M:N between bookings and rooms |
| `BookingSource` | Superclass for booking origin |
| `DirectBooking` | Direct bookings via Walk-in, Phone, or Email |
| `ThirdPartyBookingPlatform` | OTA/platform bookings with commission rates |

### Payments
| Table | Description |
|---|---|
| `Payment` | Superclass holding shared payment attributes |
| `Cash` | Cash payments with amount tendered and change given |
| `BankTransfer` | Bank transfer details including reference number |
| `CreditCard` | Card payments with card type and approval code |

---

## Design Highlights

- **Superclass/Subclass Hierarchies** — Both `Payment` and `BookingSource` use the *one relation per subclass* mapping strategy, with mandatory and disjoint specialization constraints
- **Multi-valued Attributes** — Phone numbers and emails for both `Guest` and `Staff` are extracted into separate relations to satisfy 1NF
- **Many-to-Many Resolution** — The `BookingRoom` junction table handles the M:N relationship between bookings and rooms
- **CHECK Constraints** — Enforced on `RoomStatus`, `BookingStatus`, `PaymentStatus`, and `BookingChannel` to maintain data integrity

---

## Analytical Queries & Optimization

The file includes three analytical queries with before/after performance comparison using `EXPLAIN`:

| Query | Description |
|---|---|
| **Q1** | Monthly bookings and revenue grouped by guest nationality (2024) |
| **Q3** | Weekly room occupancy rate and revenue by room type (2024) |
| **Q10** | Full payment history for a specific guest using a window function (`SUM OVER PARTITION BY`) |

### Indexes Created
```sql
idx_Booking_GuestID
idx_BookingRoom_BookingID
idx_Booking_BookingDate
idx_Room_RoomTypeID
idx_Payment_BookingID
idx_Payment_PaymentDate
idx_Booking_CheckIn_Status       -- composite for Q3 filter
idx_Payment_BookingID_Date       -- composite for Q10 join + ORDER BY
```

A **view** (`vw_WeeklyOccupancy`) was also created to simplify Q3 and separate business logic from the raw query.

---

## How to Run

> ⚠️ **Important:** The dataset is split across multiple files due to the large volume of data (200,000+ rows spanning 2022–2025). You must run them **in the exact order below** to satisfy foreign key constraints.

### Step 1 — Create the schema and base data
Run the main file first. This creates the database, all 16 tables, and inserts small reference data (RoomType, Room, BookingSource, DirectBooking, ThirdPartyBookingPlatform, Staff).

```bash
mysql -u root -p < Luminar_Boutique_Phase_5.sql
```

### Step 2 — Import bulk data files (in order)

Run each insert file in the following order. **Order matters** — later files depend on earlier ones via foreign keys.

| Order | File | Tables Populated |
|---|---|---|
| 1 | `insert_guest.sql` | `Guest` |
| 2 | `insert_booking.sql` | `Booking` |
| 3 | `insert_bookingroom.sql` | `BookingRoom` |
| 4 | `insert_payment.sql` | `Payment` |
| 5 | `insert_cash.sql` | `Cash` |
| 6 | `insert_banktransfer.sql` | `BankTransfer` |
| 7 | `insert_creditcard.sql` | `CreditCard` |

Run each via CLI:
```bash
mysql -u root -p LuminarBoutique < insert_guest.sql
mysql -u root -p LuminarBoutique < insert_booking.sql
mysql -u root -p LuminarBoutique < insert_bookingroom.sql
mysql -u root -p LuminarBoutique < insert_payment.sql
mysql -u root -p LuminarBoutique < insert_cash.sql
mysql -u root -p LuminarBoutique < insert_banktransfer.sql
mysql -u root -p LuminarBoutique < insert_creditcard.sql
```

Or import them one by one using **MySQL Workbench**: `Server > Data Import > Import from Self-Contained File`.

---

## Tech Stack

- **MySQL** — Primary implementation
- **MySQL Workbench** — Schema design and query execution
- **MS SQL Server** (via Docker) — Secondary testing environment
- **Azure Data Studio** — Interface for MS SQL Server

---

## Course Info

**ITCS442: Relational Database Design**  
Faculty of Information and Communication Technology, Mahidol University  
Semester 2/2025 | Group 11

**Team Members:**
- Paulwit Fakfaiphol
- Kulchaya Kmolnarot
- Natpapavee Pramualsuk
