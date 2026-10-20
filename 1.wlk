object pepita {
  var energia = 100
// getter
  method energia() { return energia }

// setter
  method energia(_energia) { energia = _energia }

  method volar() {
    energia = energia - 10
  }

  method comer(cantidad) {
    energia = energia + 2 * cantidad
  }
}
