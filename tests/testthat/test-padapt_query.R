test_that('Query errors',{
  expect_error(padapt_query(list_of_species = c("Astrantia major L.", "Draba muralis L."),
                            list_of_traits = NULL, preset = 'none'),
               'You must give either a trait or a valid preset!')
  expect_error(padapt_query(list_of_species = rand_species(2),
                            list_of_traits = 'SLB1'), 'Trait not found!')
})

test_that('Presets',{
  expect_equal(ncol(padapt_query(rand_species(1),
                                 preset = 'all')),78)
  expect_equal(ncol(padapt_query(rand_species(1),
                                 preset = 'hab_str')),8)
  expect_equal(ncol(padapt_query(rand_species(1),
                                 preset = 'repr')),19)
  expect_equal(ncol(padapt_query(rand_species(1),
                                 preset = 'kary')),3)
  expect_equal(ncol(padapt_query(rand_species(1),
                                 preset = 'ecol_ind')),22)
  expect_equal(ncol(padapt_query(rand_species(1),
                                 preset = 'leaf_traits')),17)

})

test_that('means / just_means',{
  expect_equal(ncol(padapt_query(rand_species(1), preset = 'leaf_traits', means = T)), 22)
  expect_equal(ncol(padapt_query(rand_species(1), preset = 'leaf_traits',
                                 means = T, just_means = T)), 6)
  expect_warning(padapt_query('Abies concolor (Gordon) Hildebr.', preset = 'leaf_traits', means = T, just_means = F))
  expect_warning(padapt_query('Abies concolor (Gordon) Hildebr.', preset = 'leaf_traits', means = T, just_means = T))
  expect_equal(nrow(padapt_query(c('Acer negundo L.','Aconitum anthora L.'), preset = 'leaf_traits')),2)
})
