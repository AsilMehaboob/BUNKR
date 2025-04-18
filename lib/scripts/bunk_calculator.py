attended = int(input("Enter the number of periods attended: "))
total = int(input("Enter the total number of periods: "))

if total <= 0:
    print("Total periods must be greater than 0.")
elif attended < 0 or attended > total:
    print("Attended periods must be between 0 and total periods.")
else:
    current_percentage = (attended / total) * 100
    print(f"Current attendance: {current_percentage:.2f}%")

    if current_percentage < 75:
        required = 3 * total - 4 * attended
        required = max(0, required)
        print(f"You need to attend {required} more periods to reach 75%.")
    elif current_percentage > 75:
        bunkable = (4 * attended - 3 * total) // 3
        bunkable = max(0, bunkable)
        print(f"You can bunk up to {bunkable} periods without dropping below 75%.")
    else:
        print("Your attendance is exactly 75%. No changes needed.")