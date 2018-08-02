/// <reference types="Cypress" />

context('login', () => {
  beforeEach(() => {
    cy.visit('/user/login')
  })

  it('login success', () => {
    cy.get('#login')
      .type('admin')

    cy.get('#password')
      .type('apslrocks')

    cy.get('#btn-login')
      .click()

    cy.location().should(location => {
      expect(location.pathname).to.eq('/menu/home')
    })
  })
})
