public class InvoiceDetailRowStore {
	
	private String invoiceRowtype; // tekst eller streg (vandretstreg)
	private String tekst;
	private String periodeDato;
	private String antal;
	private String aPris;
	private String fakturaBeloeb;
	private String saldo;
	private String rawTekst;
	
		/**
	 * @return Returns the antal.
	 */
	public String getAntal() {
		return antal;
	}
	/**
	 * @param antal
	 *            The antal to set.
	 */
	public void setAntal(String antal) {
		this.antal = antal;
	}
	/**
	 * @return Returns the aPris.
	 */
	public String getAPris() {
		return aPris;
	}
	/**
	 * @param pris
	 *            The aPris to set.
	 */
	public void setAPris(String pris) {
		aPris = pris;
	}
	/**
	 * @return Returns the fakturaBeloeb.
	 */
	public String getFakturaBeloeb() {
		return fakturaBeloeb;
	}
	/**
	 * @param fakturaBeloeb
	 *            The fakturaBeloeb to set.
	 */
	public void setFakturaBeloeb(String fakturaBeloeb) {
		this.fakturaBeloeb = fakturaBeloeb;
	}

	/**
	 * @return Returns the saldo.
	 */
	public String getSaldo() {
		return saldo;
	}
	/**
	 * @param saldo
	 *            The saldo to set.
	 */
	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}
	/**
	 * @return Returns the tekst.
	 */
	public String getTekst() {
		return tekst;
	}
	/**
	 * @param tekst
	 *            The tekst to set.
	 */
	public void setTekst(String tekst) {
		this.tekst = tekst;
	}
	/**
	 * @return Returns the invoiceRowtype.
	 */
	public String getInvoiceRowtype() {
		return invoiceRowtype;
	}
	/**
	 * @param type
	 *            The type to set.
	 */
	public void setInvoiceRowtype(String invoiceRowtype) {
		this.invoiceRowtype = invoiceRowtype;
	}

	/**
	 * @return Returns the periodeDato.
	 */
	public String getPeriodeDato() {
		return periodeDato;
	}
	/**
	 * @param periodeDato
	 *            The periodeDato to set.
	 */
	public void setPeriodeDato(String periodeDato) {
		this.periodeDato = periodeDato;
	}
	/**
	 * @return Returns the rawTekst.
	 */
	public String getRawTekst() {
		return rawTekst;
	}
	/**
	 * @param rawTekst
	 *            The rawTekst to set.
	 */
	public void setRawTekst(String rawTekst) {
		this.rawTekst = rawTekst;
	}
}