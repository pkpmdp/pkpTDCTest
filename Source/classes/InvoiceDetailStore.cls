public class InvoiceDetailStore {
	
	private String invoiceType; // type of invoice fx. 'Faktura'
    private String fakturaPeriode; // faktura periode fx 'December 2003'
    private String betalingsFrist; // last payment date
    private String kontonr; // account number
    private String girokonto; // giro number
    private String fakturaDato; // invoice date
    private String fakturanr; // invoice number
    private String side; // number of pages
    private String navn; // firstname and lastname
    private String gade; // street
    private String sted; //
    private String byOgPostnr; // zip code
    private String blank; // indeholder xslt blank tegn
    
    private List<InvoiceDetailRowStore> invoiceRows;
    
	/**
     * @return Returns the betalingsFrist.
     */
    public String getBetalingsFrist() {
        return betalingsFrist;
    }

    /**
         * @param betalingsFrist The betalingsFrist to set.
         */
    public void setBetalingsFrist(String betalingsFrist) {
        this.betalingsFrist = betalingsFrist;
    }

    /**
     * @return Returns the blank.
     */
    public String getBlank() {
        return blank;
    }

    /**
         * @param blank The blank to set.
         */
    public void setBlank(String blank) {
        this.blank = blank;
    }

    /**
     * @return Returns the byOgPostnr.
     */
    public String getByOgPostnr() {
        return byOgPostnr;
    }

    /**
         * @param byOgPostnr The byOgPostnr to set.
         */
    public void setByOgPostnr(String byOgPostnr) {
        this.byOgPostnr = byOgPostnr;
    }

    /**
     * @return Returns the fakturaDato.
     */
    public String getFakturaDato() {
        return fakturaDato;
    }

    /**
         * @param fakturaDato The fakturaDato to set.
         */
    public void setFakturaDato(String fakturaDato) {
        this.fakturaDato = fakturaDato;
    }

    /**
     * @return Returns the fakturanr.
     */
    public String getFakturanr() {
        return fakturanr;
    }

    /**
         * @param fakturanr The fakturanr to set.
         */
    public void setFakturanr(String fakturanr) {
        this.fakturanr = fakturanr;
    }

    /**
     * @return Returns the fakturaPeriode.
     */
    public String getFakturaPeriode() {
        return fakturaPeriode;
    }

    /**
         * @param fakturaPeriode The fakturaPeriode to set.
         */
    public void setFakturaPeriode(String fakturaPeriode) {
        this.fakturaPeriode = fakturaPeriode;
    }

    /**
     * @return Returns the gade.
     */
    public String getGade() {
        return gade;
    }

    /**
         * @param gade The gade to set.
         */
    public void setGade(String gade) {
        this.gade = gade;
    }

    /**
     * @return Returns the girokonto.
     */
    public String getGirokonto() {
        return girokonto;
    }

    /**
         * @param girokonto The girokonto to set.
         */
    public void setGirokonto(String girokonto) {
        this.girokonto = girokonto;
    }

    /**
     * @return Returns the kontonr.
     */
    public String getKontonr() {
        return kontonr;
    }

    /**
     * @param kontonr
     *            The kontonr to set.
     */
    public void setKontonr(String kontonr) {
        this.kontonr = kontonr;
    }

    /**
     * @return Returns the navn.
     */
    public String getNavn() {
        return navn;
    }

    /**
     * @param navn
     *            The navn to set.
     */
    public void setNavn(String navn) {
        this.navn = navn;
    }

    /**
     * @return Returns the side.
     */
    public String getSide() {
        return side;
    }

    /**
     * @param side
     *            The side to set.
     */
    public void setSide(String side) {
        this.side = side;
    }

    /**
     * @return Returns the invoiceType.
     */
    public String getInvoiceType() {
        return invoiceType;
    }

    /**
     * @param invoiceType
     *            The type to set.
     */
    public void setInvoiceType(String invoiceType) {
        this.invoiceType = invoiceType;
    }

    /**
     * @return Returns the sted.
     */
    public String getSted() {
        return sted;
    }

    /**
     * @param sted
     *            The sted to set.
     */
    public void setSted(String sted) {
        this.sted = sted;
    }
    
    public void setInvoiceRows(List<InvoiceDetailRowStore> invoiceRows){
    	this.invoiceRows=invoiceRows;
    }
    
    public List<InvoiceDetailRowStore> getInvoiceRows(){
    	return invoiceRows;
    }
    
    public boolean getCheckSted(){
    	boolean flag = false;
    	if(''.equals(sted)){
    	  	flag = true;	
    	}
    	return flag;
    }
	
}