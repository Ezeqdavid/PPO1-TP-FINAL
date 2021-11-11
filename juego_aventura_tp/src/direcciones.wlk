class Direccion {

	method siguiente(pos)

}

object izquierda inherits Direccion {

	override method siguiente(pos) = pos.left(1)

	method opuesto() = derecha

}

object derecha inherits Direccion {

	override method siguiente(pos) = pos.right(1)

	method opuesto() = izquierda

}

object abajo inherits Direccion {

	override method siguiente(pos) = pos.down(1)

	method opuesto() = arriba

}

object arriba inherits Direccion {

	override method siguiente(pos) = pos.up(1)

	method opuesto() = abajo

}

