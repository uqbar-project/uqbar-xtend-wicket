package org.uqbar.wicket.xtend

import org.apache.wicket.markup.html.link.Link
import org.apache.wicket.model.IModel
import org.eclipse.xtext.xbase.lib.Procedures.Procedure0
import org.uqbar.commons.model.UserException

/**
 * Link implementation that delegates onclick
 * to an xtend procedure
 */
class XLink<T> extends Link<T> {
	extension WicketExtensionFactoryMethods = new WicketExtensionFactoryMethods
	private Procedure0 procedure
	
	new(String id) {
		super(id)
	}
	
	new(String id, IModel model) {
		super(id, model)
	}
	
	override onClick() {
		try {
			this.apply(procedure)
		}
		catch (UserException e) {
			error(e.message)
		}
	}
	
	def void setOnClick(Procedure0 procedure) {
		this.procedure = procedure
	}
	
}