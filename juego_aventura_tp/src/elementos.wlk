import wollok.game.*
import personajes.*
import utilidades.*
import personajes.*
/* 
class Bloque {
	var property position
	const property image = "market.png" 	
	
	// agregar comportamiento	
}
*/

class PowerUp {
	const cantEner = 30
	const cantSalud = 30
	method afectar(personaje)
}

class PocionMana inherits PowerUp{
	override method afectar(personaje) {personaje.energia(personaje.energia() + cantEner/5)}
}

class VesselMana inherits PowerUp {
	override method afectar(personaje) {personaje.energia(personaje.energia() + cantEner/12)}
}

class PocionSalud inherits PowerUp {
	override method afectar(personaje) {personaje.salud(personaje.salud() + cantSalud)}
}

class VesselSalud inherits PowerUp {
	override method afectar(personaje) {personaje.salud(personaje.salud() + cantSalud/5)}
}

class Monedas inherits PowerUp {
	override method afectar(personaje) {personaje.dinero(personaje.dinero() + 5)}
}



class CeldaSorpresa {
	
}



