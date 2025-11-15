---
id: 1763224468-microservices
aliases:
  - Microservices
tags: []
publish: false
created: 2025-11-16 00:34
modified: 2025-11-16 00:34
title: Microservices
---

# Microservices
Sekumpulan *service* yang dapat berdiri sendiri. Tidak terpaku terhadap satu bahasa pemrograman layaknya [[system-architecture/1763224515-monolith|Monolith]], dapat melakukan perubahan apapun dalam tiap *service* tanpa mengganggu jalannya aplikasi secara keseluruhan. Tidak selayaknya misalkan kita menggunakan [[1763224944-laravel|Laravel]] yang basisnya menggunakan PHP, kemudian kita salah menulis kode PHP, kemudian kita tidak mempunyai *proper test and deployment*, kita akan mendapati aplikasi tidak akan bisa dibuka atau terdapat *error* secara global, walaupun kode PHP yang salah ini hanya ada di bagian salah *module* saja, namun keseluruhan *module* akan terdampak.