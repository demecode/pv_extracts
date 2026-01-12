from datetime import date
from pathlib import Path
import random
from openpyxl import Workbook

random.seed(42)

def month_start(y, m):
    return date(y, m, 1)

def add_months(d, n):
    y = d.year + (d.month - 1 + n) // 12
    m = (d.month - 1 + n) % 12 + 1
    return date(y, m, 1)

def write_historic_snapshot_xlsx(out_path: Path, customer_id: str, contract_id: str, facilities):
    wb = Workbook()
    ws = wb.active
    ws.title = "Facility_Monthly"
    ws.append([
        "customer_id","contract_id","facility_id","month",
        "opening_balance","drawn_this_month","repaid_this_month","closing_balance","currency"
    ])

    start = month_start(2024, 1)
    months = [add_months(start, i) for i in range(0, 6)]  # Jan..Jun

    for fac_id, currency in facilities:
        bal = 0
        for i, m in enumerate(months):
            # introduce a missing month for one facility
            if fac_id.endswith("02") and m.month == 2:
                continue

            opening = bal

            draw = random.choice([0, 25000, 50000, 75000])
            repay = random.choice([0, 10000, 25000])

            # keep repay <= opening+draw
            repay = min(repay, opening + draw)

            closing = opening + draw - repay

            # introduce a mismatch (bad manual edit)
            if fac_id.endswith("01") and m.month == 4:
                closing += 5000  # deliberate inconsistency

            # introduce a carry-forward break (opening wrong next month) by bumping bal
            bal = closing
            if fac_id.endswith("02") and m.month == 3:
                bal += 12000  # next row opening will not match last closing (simulated edit)

            ws.append([customer_id, contract_id, fac_id, m.isoformat(),
                       float(opening), float(draw), float(repay), float(closing), currency])

    out_path.parent.mkdir(parents=True, exist_ok=True)
    wb.save(out_path)

def write_lti_transactions_xlsx(out_path: Path, customer_id: str, contract_id: str, facilities):
    wb = Workbook()
    ws = wb.active
    ws.title = "Draw_Repay"
    ws.append([
        "customer_id","contract_id","facility_id","transaction_date",
        "transaction_type","amount","reference","currency"
    ])

    # event dates across months
    event_dates = [
        date(2024,1,15), date(2024,1,28),
        date(2024,2,12),
        date(2024,3,5), date(2024,3,20),
        date(2024,4,10),
        date(2024,5,2), date(2024,5,18),
        date(2024,6,7)
    ]

    for fac_id, currency in facilities:
        bal = 0
        for idx, dt in enumerate(event_dates):
            # mix draws and repays
            if bal < 150000 and random.random() < 0.7:
                typ = "DRAW"
                amt = random.choice([25000, 50000, 75000])
                bal += amt
            else:
                typ = "REPAY"
                amt = random.choice([10000, 25000, 50000])
                amt = min(amt, bal)
                if amt == 0:
                    continue
                bal -= amt

            ref = f"{contract_id}:{fac_id}:{dt.isoformat()}:{typ}:{idx}"
            ws.append([customer_id, contract_id, fac_id, dt.isoformat(), typ, float(amt), ref, currency])

    out_path.parent.mkdir(parents=True, exist_ok=True)
    wb.save(out_path)

def main():
    # Generate 2 contracts, each with 2 facilities
    jobs = [
        ("CUST001","CON001", [("CON001_FAC01","GBP"), ("CON001_FAC02","GBP")]),
        ("CUST002","CON014", [("CON014_FAC01","GBP"), ("CON014_FAC02","GBP")]),
    ]

    # Historic (SharePoint-like)
    for cust, con, facs in jobs:
        write_historic_snapshot_xlsx(
            Path(f"extracts/sharepoint_workbooks/{cust}_{con}_HIST.xlsx"), cust, con, facs
        )

    # LTI (GitHub-like)
    for cust, con, facs in jobs:
        write_lti_transactions_xlsx(
            Path(f"extracts/github_workbooks/{cust}_{con}_LTI.xlsx"), cust, con, facs
        )

    print("Wrote dummy historic and LTI workbooks under extracts/")

if __name__ == "__main__":
    main()