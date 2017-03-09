global class Role implements Comparable{
        public string position{get;set;}
        public string name{get;set;}
        
        public Role(string p, string n){
            position = p;
            name = n;
        }
        
        global Integer compareTo(Object compareTo) {
        Role compareToRole = (Role)compareTo;
        if (position == compareToRole.position) return 0;
        if (position > compareToRole.position) return 1;
        return -1;        
    }

    }