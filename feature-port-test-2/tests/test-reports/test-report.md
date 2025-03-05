# Test Results Summary
Generated at: Wed Mar  5 00:07:09 UTC 2025
\n## Overview
\n### 🔒 Mandatory Tests
```
============================= test session starts ==============================
platform linux -- Python 3.11.11, pytest-8.3.5, pluggy-1.5.0 -- /opt/hostedtoolcache/Python/3.11.11/x64/bin/python
cachedir: .pytest_cache
rootdir: /home/runner/work/microServiceCICDTest/microServiceCICDTest/feature-port-test-2
plugins: cov-6.0.0
collecting ... collected 1 item

tests/test_mandatory.py::test_health_check PASSED                        [100%]

============================== 1 passed in 0.01s ===============================
```
\n### 📝 Recommended Tests
```
============================= test session starts ==============================
platform linux -- Python 3.11.11, pytest-8.3.5, pluggy-1.5.0 -- /opt/hostedtoolcache/Python/3.11.11/x64/bin/python
cachedir: .pytest_cache
rootdir: /home/runner/work/microServiceCICDTest/microServiceCICDTest/feature-port-test-2
plugins: cov-6.0.0
collecting ... collected 0 items

============================ no tests ran in 0.01s =============================
```
\n### ⭐ Optional Tests
```
============================= test session starts ==============================
platform linux -- Python 3.11.11, pytest-8.3.5, pluggy-1.5.0 -- /opt/hostedtoolcache/Python/3.11.11/x64/bin/python
cachedir: .pytest_cache
rootdir: /home/runner/work/microServiceCICDTest/microServiceCICDTest/feature-port-test-2
plugins: cov-6.0.0
collecting ... collected 0 items

============================ no tests ran in 0.01s =============================
```
\n## Coverage Reports
\n### Mandatory Tests Coverage
```
Name                        Stmts   Miss  Cover
-----------------------------------------------
app.py                          9      3    67%
tests/__init__.py               0      0   100%
tests/conftest.py               7      3    57%
tests/test_mandatory.py         7      7     0%
tests/test_optional.py          4      0   100%
tests/test_recommended.py       3      3     0%
-----------------------------------------------
TOTAL                          30     16    47%
```
\n## Test Status Summary
| Test Type | Status |
|-----------|--------|
| Mandatory | ✅ Passed |
| Recommended | ⚠️ Some tests failed |
| Optional | ℹ️ Some tests failed |
