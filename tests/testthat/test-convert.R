test_that('convert works as intended',{
  expect_equal(convert(b_dat$Species[1])$correct, "Achillea collina Becker ex Rchb.")
  expect_equal(length(convert(b_dat$Species[1:2])), 2)
  expect_equal(length(convert(b_dat$Species[1:2], table = T)), 3)
})

test_that('Duplicates from typos',{
  expect_equal(length(convert(c("Dactylis glomerata","Dactyilis glomerata" ))$correct),1)
})

test_that('Df',{
  expect_equal(class(convert(b_dat$Species[1:2], table = T)$df), 'data.frame')
})

test_that("Error warning",{
  expect_warning(convert(c('Centaurea phrygia','Lathyrus inconspicuus')))
})
