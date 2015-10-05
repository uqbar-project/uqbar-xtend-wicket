package org.uqbar.wicket.xtend

import org.apache.wicket.WicketRuntimeException
import org.apache.wicket.markup.html.form.Form
import org.apache.wicket.markup.html.form.IFormSubmitter
import org.apache.wicket.model.IModel
import org.uqbar.commons.model.UserException

/**
 * Subclasses wicket's Form in order to correctly handle
 * UserExceptions within setters.
 */
class XForm<T> extends Form<T> {
	
	new(String id) {
		super(id)
	}
	
	new(String id, IModel model) {
		super(id, model)
	}
	
	override process(IFormSubmitter submittingComponent) {
		try {
			super.process(submittingComponent)
		}
		catch (WicketRuntimeException e) {
			if (e.cause instanceof UserException) {
				error(e.cause.message)
			}
			else {
				throw e
			}
		}
	}
	
}