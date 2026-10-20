object galvan {
  var sueldo = 15000

  method sueldo() = sueldo
  method sueldo(_sueldo) { sueldo = _sueldo }
}

object baigorria {
  var cantidadEmpanadasVendidas = 100
  const montoPorEmpanada = 15

  method venderEmpanada() {
    cantidadEmpanadasVendidas = cantidadEmpanadasVendidas + 1 
  }

  method sueldo() = cantidadEmpanadasVendidas * montoPorEmpanada
}

object gimenez {
   var dinero = 300000
	
   method dinero() = dinero 
   method pagarA(empleado) { dinero = dinero - empleado.sueldo() }
}
