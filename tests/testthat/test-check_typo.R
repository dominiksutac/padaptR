test_that('Check_typo if all is good',{
  expect_message(check_typo("Ranunculus fluitans Lam."))
})

test_that('Check_typo warning',{
  expect_warning(check_typo("Ranunculus fluitans"))
  expect_equal(ncol(check_typo(c('Albus paar','Populo tera'), to_return = T)),2)
  expect_null(ncol(check_typo(c('Albus paar','Populo tera'), to_return = F)))
})

test_that('Check_typo_trait verbose',{
  expect_message(check_typo_trait(c('SLA1','SLA2'), verbose = T))
  expect_no_message(check_typo_trait(c('SLA1','SLA2'), verbose = F))
})

test_that('Check_typo_trait working',{
  expect_warning(check_typo_trait('SLA'))
  expect_false(check_typo_trait('SLA'))
})
