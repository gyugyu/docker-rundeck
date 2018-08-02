/// <reference types="Cypress" />

context('index', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('redirect to /user/login', () => {
    cy.location().should(location => {
      expect(location.pathname).to.eq('/user/login')
    })
  })
})
