import wollok.game.*
import personajes.*
import utilidades.*
import personajes.*
import direcciones.*
import nivel1.*
import nivel2.*
import nivel3.*


class Elemento {
	method recibirDanio() {}
	method esMovible() = true
	method esEnemigo() = false
	method reaccionar(personaje) {}
	method hayAlgo() = true
}

class Fondo inherits Elemento{

	const property position = game.at(0, 0)
	var property image = "fondoCompleto.png"
	override method hayAlgo() = false
}

class PowerUp inherits Elemento{
	var property position = utilidadesParaJuego.posicionArbitraria()
	var property image = "flask_big_blue.png"
	
	method initialize() {
		nivelBloques.powerUpsEnNivel(nivelBloques.powerUpsEnNivel() + 1) 
		nivelConEnemigos.powerUpsEnNivel(nivelConEnemigos.powerUpsEnNivel() + 1) 
		nivelMonedas.powerUpsEnNivel(nivelMonedas.powerUpsEnNivel() + 1)
	}
	
	override method reaccionar(personaje) {
		const sound = new Sound(file = "powerUp.mp3")
		sound.volume(0.7)
		sound.play()
		nivelBloques.powerUpsEnNivel(nivelBloques.powerUpsEnNivel() - 1) 
		nivelConEnemigos.powerUpsEnNivel(nivelConEnemigos.powerUpsEnNivel() - 1) 
		nivelMonedas.powerUpsEnNivel(nivelMonedas.powerUpsEnNivel() - 1)
		game.removeVisual(self)
	}
}

class PocionMana inherits PowerUp{
	override method initialize() {
		super()
		self.image("flask_big_blue.png")
	}
	override method reaccionar(personaje) {super(personaje) personaje.energia(personaje.energia() + 20)}
}

class VesselMana inherits PowerUp {
	override method initialize() {
		super()
		self.image("flask_blue.png")
	}
	override method reaccionar(personaje) {super(personaje) personaje.energia(personaje.energia() + 10)}
}

class PocionSalud inherits PowerUp {
	override method initialize() {
		super()
		self.image("flask_big_red.png")
	}
	override method reaccionar(personaje) {super(personaje) personaje.salud(personaje.salud() + 20)}
}

class VesselSalud inherits PowerUp {
	override method initialize() {
		super()
		self.image("flask_red.png")
	}
	override method reaccionar(personaje) {super(personaje) personaje.salud(personaje.salud() + 10)}
}

class Monedas inherits PowerUp {
	override method initialize() {
		super()
		self.image("coin_anim_f0.png")
	}
	override method reaccionar(personaje) {super(personaje) personaje.dinero(personaje.dinero() + 5)}
}

class MonedaSanguinaria inherits Monedas {
	override method initialize() {
		super()
		self.image("monedaSanguinaria.png")
		nivelMonedas.monedasEnNivel(nivelMonedas.monedasEnNivel() + 1)
	}

	override method reaccionar(personaje) {
		super(personaje) 
		personaje.salud(personaje.salud() - 5)
		
		nivelMonedas.monedasEnNivel(nivelMonedas.monedasEnNivel() - 1)
		
		nivelMonedas.aparecerSalida()
	}
}

class Cofre inherits Elemento{
	const property image = "chest_empty_open_anim_f0.png"
	
	var property position = utilidadesParaJuego.posicionArbitrariaParaCofres() 

	override method reaccionar(personaje) {
		const sound = new Sound(file = "colisioncaja.mp3")
		const newPosition = personaje.direccion().siguiente(position)
		sound.play()
		if (newPosition.y() != game.height() and 
			newPosition.x() != game.width() and
			newPosition.x() != -1 and 
			newPosition.y() != -1) {
			
			position = newPosition	
		}
	}

}

class FragmentoEspada  inherits Elemento{
	const property image = "Broken_golden_sword.png"
	var property position = utilidadesParaJuego.posicionArbitraria()
	override method reaccionar(personaje) {
		const sound = new Sound(file = "logro.mp3")
		sound.volume(0.7)
		sound.play()
		personaje.recogerFragmento(self)
		game.removeVisual(self)
	}
}

class CeldaSorpresa inherits Elemento{
	const property image = "celdaSorpresa.png"
	var property position = utilidadesParaJuego.posicionArbitraria()
	override method reaccionar(personaje) {game.removeVisual(self)} 
}

class CeldaQuitaEnergia inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.energia(personaje.energia() - 15)
	}
}

class CeldaAgregaEnergia inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.energia(personaje.energia() + 30)
	}
}

class CeldaTeletransportadora inherits CeldaSorpresa {
	override method reaccionar(personaje) {
		super(personaje)
		personaje.position(utilidadesParaJuego.posicionArbitraria())
	}
}

class Indicador inherits Elemento{
	var property position
	var property image = null
	method visualizar(personaje)

	override method esMovible() = false
}

class IndicadorSalud inherits Indicador {
	method initialize() {
		self.image("ui_heart_full.png")
		self.position(game.at(0,0))
	} 

	override method visualizar(personaje) {
		if (personaje.salud() <= 15) {
			image = "ui_heart_half.png" 
		} else {
			image = "ui_heart_full.png"
		}
	}
}

class IndicadorEnergia inherits Indicador {

	method initialize() {
		self.image("Energia_full.png")
		self.position(game.at(1,0))
	}
	
	override method visualizar(personaje) {
		if (personaje.energia() <= 50) {
			image = "Energia_half.png"
		} else {
			image = "Energia_full.png"
		}
	}
}

object forja inherits Elemento{
	const property image = "wall_fountain_basin_red_anim_f0.png"
	const property position = game.at(13,1)
	var property fragmentos = []
	var property objetivoLogrado = false
	
	override method esMovible() {return false}
	
	override method reaccionar(personaje) {
		const sound = new Sound(file = "logro.mp3")
		sound.volume(0.7)
		sound.play()
		fragmentos.addAll(personaje.fragmentos())
		personaje.dejarFragmentos()
		game.say(self, "Juntaste " + fragmentos.size().stringValue() + " , ya casi está todo.")
		if (fragmentos.size() == 4) {
			self.objetivoLogrado(true)
		}
		nivelBloques.verificaFinDeNivel()
	}
}

object escalera inherits Elemento{
	const property image = "Escalera.png"
	const property position = game.at(0,13)
	var property cofresPisoInferior = []
	var property objetivoLogrado = false
	
	override method esMovible() {return false}
	
	override method reaccionar(cofre) {
		const sound = new Sound(file = "logro.mp3")
		sound.volume(0.7)
		sound.play()
		cofresPisoInferior.add(cofre)
		game.removeVisual(cofre)
		game.say(self, "Bajaste " + cofresPisoInferior.size().stringValue() + " , dale que falta poco.")
		if (cofresPisoInferior.size() == 3) {
			self.objetivoLogrado(true)
		}
		nivelBloques.verificaFinDeNivel()
	}
}

class Espada inherits Elemento{
	var property position
	var property image = null
	var property direccion
	
	method initialize() {
		self.spriteCorrecto()
	} 
	
	method spriteCorrecto() {
		if (self.direccion().esArriba()) {
			self.image("espadaDorada_arriba.png")
		} else if (self.direccion().esDerecha()) {
			self.image("espadaDorada_derecha.png")
		} else if (self.direccion().esAbajo()) {
			self.image("espadaDorada_abajo.png")
		} else if (self.direccion().esIzquierda()) {
			self.image("espadaDorada_izquierda.png")
		}
	}
	
	method daniar(enemigo){
		enemigo.recibirDanio()
	}
	
	method avanzar(personaje){
		position = direccion.siguiente(position)
	}
}

object puertaSalida inherits Elemento{
	const property image = "door_open.png"
	const property position = utilidadesParaJuego.posicionArbitraria()
	
	override method reaccionar(personaje) {
		nivelMonedas.verificaFinDeNivel()
	}
}



