class Guerrero {
  var property potencialOfensivo
  var property experiencia = 0
  const energiaInicial
  var property energia = energiaInicial
  var property traje

  method atacar(unGuerrero) {
    unGuerrero.recibirAtaque(self)
  }

  method recibirAtaque(unAtacante) {
    const danioBase = unAtacante.potencialOfensivo() * 0.10
    const danioReal = traje.calcularDanio(danioBase)
    
    energia = 0.max(energia - danioReal)
    experiencia += 1 * traje.multiplicadorExperiencia()
    traje.usar()
  }

  method comerSemilla() {
    energia = energiaInicial
  }

  method cantidadElementosTraje() = traje.cantidadElementos()

}

// --- PUNTO 2: TRAJES ---

class Traje {
  var property desgaste = 0

  method estaGastado() = desgaste >= 100

  method cantidadElementos() = 1

  method usar() {
    desgaste = 100.min(desgaste + 5)
  }

  method calcularDanio(danioBase) = 
    if (self.estaGastado()) danioBase else self.danioConProteccion(danioBase)

  method multiplicadorExperiencia() = 1

  method danioConProteccion(danioBase) = danioBase
  
}

class TrajeComun inherits Traje {
  var property porcentajeProteccion

  override method danioConProteccion(danioBase) = 
    danioBase * (1 - porcentajeProteccion / 100)
}

class TrajeEntrenamiento inherits Traje {
  override method multiplicadorExperiencia() = 
    if (self.estaGastado()) 1 else nivelEntrenamiento.multiplicador()

}

object nivelEntrenamiento {
  var property multiplicador = 2
}

// --- PUNTO 3 y 4 : TRAJE MODULARIZADO Y PIEZAS

class TrajeModularizado inherits Traje {
  const property piezas = []

  // Esta gastado si todas sus piezas están gastadas
  override method estaGastado() = piezas.all({ pieza => pieza.estaGastada() })

  // Al usar el traje se usan sus piezas
  override method usar() {
    piezas.forEach({ pieza => pieza.usar() })
  }

  override method cantidadElementos() = piezas.size()

  method piezasSanas() = piezas.filter({ pieza => !pieza.estaGastada() })

  method resistenciaTotal() = self.piezasSanas().sum({ pieza => pieza.resistencia() })

  override method danioConProteccion(danioBase) = 
    0.max(danioBase - self.resistenciaTotal())

override method multiplicadorExperiencia() = 
    if (piezas.isEmpty()) 0 else self.piezasSanas().size() / piezas.size() 

}

class Pieza {
  const property resistencia
  var property desgaste = 0

  method estaGastada() = desgaste >= 20

 // se considera el desgaste de una pieza como si fuera un traje
  method usar() {
    desgaste = 20.min(desgaste + 5)
  }
}

// --- PUNTO 5 : TIPOS DE TORNEO

class Torneo {
  const property aspirantes = []
  var property modalidad = powerIsBest

  method agregarAspirante(unGuerrero) {
    aspirantes.add(unGuerrero)
  }

  method seleccionarParticipantes() = modalidad.seleccionar(aspirantes)
}

class ModalidadPorCriterio {
  method seleccionar(guerreros) = 
    self.ordenar(guerreros).take(16)

  method ordenar(guerreros) = 
    guerreros.sortedBy({ g1, g2 => self.puntaje(g1) > self.puntaje(g2) })

  // Metodo abstracto 
  method puntaje(unGuerrero)
}

object powerIsBest inherits ModalidadPorCriterio {
  override method puntaje(unGuerrero) = unGuerrero.potencialOfensivo()
}

object funny inherits ModalidadPorCriterio {
  override method puntaje(unGuerrero) = unGuerrero.cantidadElementosTraje()
}

 object surprise {

  method seleccionar(guerreros) {
    // clonamos la lista para no borrar los aspirantes al torneo
    const disponibles = guerreros.copy()
    const seleccionados = []

    // si los aspirantes son menos de 16
    const cantidadAElegir = 16.min(guerreros.size())

    // se repite la extraccion hasta 16 o si hay menos
    cantidadAElegir.times({ i =>
      const elegido = disponibles.anyOne() // Agarra uno al azar
      seleccionados.add(elegido)           // Lo guarda en los elegidos
      disponibles.remove(elegido)          // Lo borra de la bolsa para no repetir
    })
    return seleccionados
  }
} 