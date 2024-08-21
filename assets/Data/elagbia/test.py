# Define the Coptic months
copticMonths = [
  'توت',
  'بابه',
  'هاتور',
  'كيهك',
  'طوبه',
  'أمشير',
  'برمهات',
  'برموده',
  'بشنس',
  'بؤونه',
  'أبيب',
  'مسري',
  'نسئ'
]

# Generate list of dictionaries for Coptic dates
coptic_dates = []

# First 12 months with 30 days each
for month in copticMonths[:-1]:
    for day in range(1, 31):
        coptic_dates.append({'date': f'{month} {day}', 'text': ''})

# Last month (Nesi) with 5 or 6 days
for day in range(1, 6):
    coptic_dates.append({'date': f'{copticMonths[-1]} {day}', 'text': ''})

print(coptic_dates)
