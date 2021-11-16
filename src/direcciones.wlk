class Direccion {

	method siguiente(pos)
	method esArriba() = false
	method esAbajo() = false
	method esIzquierda() = false
	method esDerecha() = false
}

object izquierda inherits Direccion {

	override method siguiente(pos) = pos.left(1)
	override method esIzquierda() = true
	method opuesto() = derecha

}

object derecha inherits Direccion {

	override method siguiente(pos) = pos.right(1)
	override method esDerecha() = true
	method opuesto() = izquierda

}

object abajo inherits Direccion {

	override method siguiente(pos) = pos.down(1)
	override method esAbajo() = true
	method opuesto() = arriba

}

object arriba inherits Direccion {
	
	override method siguiente(pos) = pos.up(1)
	override method esArriba() = true
	method opuesto() = abajo

}

