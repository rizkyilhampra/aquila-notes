---
id: 1728351874-function-to-sanitize-indonesian-currency-format
aliases:
  - Function to Sanitize Indonesian Currency Format
tags: []
---

# Function to Sanitize Indonesian Currency Format

## PHP

```php
<?php
/**
 * Sanitizes a string representation of a number by removing thousand separators
 * and converting the decimal separator from a comma to a dot.
 *
 * @param string $number - The string representing the number to sanitize.
 * @return ?float - The sanitized floating-point number, or `null` if the input is not a valid number.
 *
 */
function sanitizeNumber(string $number): ?float
{
    $val = preg_replace('/\s+/', '', $number);
    if (empty($val)) {
        return null;
    }

    $val = str_replace(',', '.', $val);
    $val = preg_replace("/[\,\.](\d{3})/", '$1', $val);

    if (! is_numeric($val)) {
        return null;
    }

    return (float) $val;
}
```

### Test Cases

```php
<?php
$testCases = [
    '1.234,56' => 1234.56,
    '10.000' => 10000.0,
    '12,34' => 12.34,
    '' => null,
    'abc' => null,
    '1,234.56' => 1234.56,
    '1 234,56' => 1234.56,
    '-1.234,56' => -1234.56,
    '1.234.567,89' => 1234567.89,
    '10.000,50' => 10000.5,
];

foreach ($testCases as $input => $expected) {
    $result = sanitizeNumber($input);

    echo sprintf(
        "Input: '%s' (%s) => Expected: %s (%s), Got: %s (%s)\n",
        $input,
        gettype($input),
        var_export($expected, true),
        gettype($expected),
        var_export($result, true),
        gettype($result)
    );

    echo $result === $expected ? "Test Passed\n\n" : "Test Failed\n\n";
}
```

```stdout
Input: '1.234,56' (string) => Expected: 1234.56 (double), Got: 1234.56 (double)
Test Passed

Input: '10.000' (string) => Expected: 10000.0 (double), Got: 10000.0 (double)
Test Passed

Input: '12,34' (string) => Expected: 12.34 (double), Got: 12.34 (double)
Test Passed

Input: '' (string) => Expected: NULL (NULL), Got: NULL (NULL)
Test Passed

Input: 'abc' (string) => Expected: NULL (NULL), Got: NULL (NULL)
Test Passed

Input: '1,234.56' (string) => Expected: 1234.56 (double), Got: 1234.56 (double)
Test Passed

Input: '1 234,56' (string) => Expected: 1234.56 (double), Got: 1234.56 (double)
Test Passed

Input: '-1.234,56' (string) => Expected: -1234.56 (double), Got: -1234.56 (double)
Test Passed

Input: '1.234.567,89' (string) => Expected: 1234567.89 (double), Got: 1234567.89 (double)
Test Passed

Input: '10.000,50' (string) => Expected: 10000.5 (double), Got: 10000.5 (double)
Test Passed
```

## Javascript

```javascript
/**
 * Sanitizes a string representation of a number by removing thousand separators
 * and converting the decimal separator from a comma to a dot.
 *
 * @param {string} number - The string representing the number to sanitize.
 * @returns {?number} - The sanitized floating-point number, or `null` if the input is not a valid number.
 *
 */
function sanitizeNumber(number) {
  number = number.replace(/\s+/g, "");
  if (number === "") return null;

  let val = number.replace(",", ".");
  val = val.replace(/[,.](\d{3})/g, "$1");
  val = parseFloat(val);

  return isNaN(val) ? null : val;
}
```

### Test Cases

```javascript
const testCases = {
  "1.234,56": 1234.56,
  "10.000": 10000.0,
  "12,34": 12.34,
  "": null,
  abc: null,
  "1,234.56": 1234.56,
  "1 234,56": 1234.56,
  "-1.234,56": -1234.56,
  "1.234.567,89": 1234567.89,
  "10.000,50": 10000.5,
};

for (const [input, expected] of Object.entries(testCases)) {
  const result = sanitizeNumber(input);

  console.log(
    `Input: '${input}' => Expected: ${expected} (${typeof expected}), Got: ${result} (${typeof result})`,
  );
  console.log(result === expected ? "Test Passed\n" : "Test Failed\n");
}
```

```stdout
Input: '1.234,56' => Expected: 1234.56 (number), Got: 1234.56 (number)
Test Passed

Input: '10.000' => Expected: 10000 (number), Got: 10000 (number)
Test Passed

Input: '12,34' => Expected: 12.34 (number), Got: 12.34 (number)
Test Passed

Input: '' => Expected: null (object), Got: null (object)
Test Passed

Input: 'abc' => Expected: null (object), Got: null (object)
Test Passed

Input: '1,234.56' => Expected: 1234.56 (number), Got: 1234.56 (number)
Test Passed

Input: '1 234,56' => Expected: 1234.56 (number), Got: 1234.56 (number)
Test Passed

Input: '-1.234,56' => Expected: -1234.56 (number), Got: -1234.56 (number)
Test Passed

Input: '1.234.567,89' => Expected: 1234567.89 (number), Got: 1234567.89 (number)
Test Passed

Input: '10.000,50' => Expected: 10000.5 (number), Got: 10000.5 (number)
Test Passed
```
