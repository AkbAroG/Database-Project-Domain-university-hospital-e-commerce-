import random
from datetime import datetime, timedelta

# SQL file open
f = open("hospital_transactions_20k.sql", "w")

f.write("USE HospitalDataBase;\nGO\n\n")

# ================================
# A. APPOINTMENT NOTES (12,000)
# ================================
f.write("-- Appointment Notes (12,000)\n")

notes = [
    'Patient stable',
    'Follow-up required',
    'Prescribed medication',
    'Condition improving',
    'Needs further tests',
    'Emergency handled',
    'Admitted for observation'
]

note_id = 1

for i in range(12000):
    appointment_id = random.randint(1, 20)   # existing appointments
    note = random.choice(notes)

    f.write(
        f"INSERT INTO AppointmentNotes (AppointmentID, Note) "
        f"VALUES ({appointment_id}, '{note}');\n"
    )

# ================================
# B. INVOICE LINES (8,000)
# ================================
f.write("\n-- Invoice Transactions (8,000)\n")

descriptions = [
    'Consultation Fee',
    'Medicine Charges',
    'Lab Test',
    'X-Ray',
    'MRI Scan',
    'Emergency Charges',
    'Room Charges'
]

for i in range(8000):
    invoice_id = random.randint(1, 10)   # existing invoices
    desc = random.choice(descriptions)
    amount = random.randint(500, 20000)

    f.write(
        f"INSERT INTO InvoiceLines (InvoiceID, Description, Amount) "
        f"VALUES ({invoice_id}, '{desc}', {amount});\n"
    )

f.close()

print("✅ Hospital 20,000 transaction SQL file generated successfully!")
