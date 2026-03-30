test_that('Search_species works as intended',{
  expect_equal(length(search_species('Stipa')), 8)
  expect_error(search_species('Stp'))
  expect_error(search_species(1))
})
