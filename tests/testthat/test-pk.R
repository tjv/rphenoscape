context("rphenoscape test")

test_that("Test term search", {
  skip_on_cran()
  a <- pk_taxon_detail("Coralliozetus")
  b <- pk_phenotype_detail("shape")
  c <- pk_anatomical_detail("basihyal bone")

  aa <- pk_taxon_detail("coral tt")
  bb <- pk_phenotype_detail("shape tt")
  cc <- pk_anatomical_detail("fin tt")


  g <- pk_gene_detail("socs5")
  gg <- pk_gene_detail("socs5", "Danio rerio")

  expect_is(a, 'data.frame')
  expect_is(b, 'data.frame')
  expect_is(c, 'data.frame')


  expect_equal(aa, FALSE)
  expect_equal(bb, FALSE)
  expect_equal(cc, FALSE)

  expect_is(g, "data.frame")
  expect_is(gg, "data.frame")
})

test_that("Test retriving IRI", {
  skip_on_cran()
  i <- pk_get_iri("Coralliozetus", "vto")
  ii <- pk_get_iri("Coralliozetus TT", "vto")
  iii <- pk_get_iri("Coralliozetus", "pato")

  expect_equal(i, "http://purl.obolibrary.org/obo/VTO_0042955")
  expect_equal(ii, FALSE)
  expect_equal(iii, FALSE)
})


test_that("Test getting classification information", {
  skip_on_cran()
  t <- pk_taxon_class("Fisherichthys")
  tt <- pk_taxon_class("Fisherichthys folmeri")
  ttt <- pk_taxon_class("Fisherichthys TT")

  a <- pk_anatomical_class("fin")
  aa <- pk_anatomical_class("fin FF")

  p <- pk_phenotype_class("shape")
  pp <- pk_phenotype_class("shape SS")

  expect_output(str(t), 'List of 5')
  expect_output(str(tt), 'List of 5')
  expect_equal(ttt, FALSE)

  expect_output(str(a), 'List of 5')
  expect_equal(aa, FALSE)

  expect_output(str(p), 'List of 5')
  expect_equal(pp, FALSE)

})

test_that("Test Descendant/Ancestor", {
  skip_on_cran()
  fl <- pk_is_descendant("Halecostomi", c("Halecostomi", "Icteria", "Sciaenidae"))
  tl <- pk_is_ancestor("Sciaenidae", c("Halecostomi", "Abeomelomys", "Sciaenidae"))

  expect_equal(fl, c(F, F, T))
  expect_equal(tl, c(T, F, F))
})

test_that("Test OnToTrace", {
  skip_on_cran()
  single_nex <- pk_get_ontotrace_xml(taxon = "Ictalurus", entity = "fin")
  multi_nex <- pk_get_ontotrace_xml(taxon = c("Ictalurus", "Ameiurus"), entity = c("fin spine", "pelvic splint"))

  expect_s4_class(single_nex, 'nexml')
  expect_s4_class(multi_nex, 'nexml')

  err1 <- function() pk_get_ontotrace_xml(taxon = "Ictalurus TT", entity = "fin", relation = "other relation")

  f1 <- pk_get_ontotrace_xml(taxon = c("Ictalurus", "Ameiurus XXX"), entity = c("fin", "spine"))
  f2 <- pk_get_ontotrace_xml("Ictalurus TT", "fin")

  expect_error(err1())
  expect_equal(f1, FALSE)
  expect_equal(f2, FALSE)

  single_mat <- pk_get_ontotrace(single_nex)
  multi_mat <- pk_get_ontotrace(multi_nex)

  expect_is(single_mat, 'data.frame')
  expect_is(multi_mat, 'data.frame')

  single_met <- pk_get_ontotrace_meta(single_nex)

  expect_is(single_met, 'list')

})

#
test_that("Test getting study information", {
    skip_on_cran()
    slist <- pk_get_study_list(taxon = "Ameiurus", entity = "pelvic splint")
    s1 <- pk_get_study_xml('https://scholar.google.com/scholar?q=The+Phylogeny+of+Ictalurid+Catfishes%3A+A+Synthesis+of+Recent+Work&btnG=&hl=en&as_sdt=0%2C42')
    ss1 <- pk_get_study(s1)
    sss1 <- pk_get_study_meta(s1)

    expect_is(slist, 'data.frame')
    expect_is(s1[[1]], 'nexml')
    expect_is(ss1[[1]], 'data.frame')
    expect_is(sss1[[1]], 'list')
    expect_is(sss1[[1]]$id_taxa, 'data.frame')

})



