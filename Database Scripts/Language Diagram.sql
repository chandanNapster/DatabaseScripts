Create (cq:CQ{name:"CQ"})-[:add]->(crpq:CRPQ{name:"C2RPQ"})<-[:add]-(rpq:RPQ{name:"2RPQ"}),
        (cq)-[:add_Union]->(ucq:UCQ{name:"UCQ"}),
        (crpq)-[:add_Union]->(ucrpq:UCRPQ{name:"UC2RPQ"}),
        (rpq)-[:add_Branching]->(nre:NRE{name:"NRE"}),
        (cq)-[:add]->(cnre:CNRE{name:"CNRE"})<-[:add]-(nre),
        (nre)-[:add_Intersection]->(ta:TA{name:"TA"}),
        (ta)-[:add]->(cqt:CQT{name:"CQT"})<-[:add]-(cq),
        (cqt)-[:add_Union]->(ucqt:UCQT{name:"UCQT"}),
        (cnre)-[:add_Union]->(ucnre:UCNRE{name:"UNC2RPQ"}),
        (crpq)-[:add_Regular_Relations]->(ecrpq:ECRPQ{name:"ECRPQ_re"}),
        (crpq)-[:add_Rational_Relations]->(eecrpq:EECRPQ{name:"ECRPQ_ra"}),
        (rp:RP{name:"RPQ"})-[:add_Inverse]->(rpq),
        (cqt)-[:addn]->(cqtre:CQTre{name:"CQT_re"}),
        (ecrpq)-[:addn]->(cqtre),
        (cqtre)-[:add_Union]->(ucqtre:UCQTre{name:"UCQT_re"})


--QUERY
Match (a) return a
Match (a) detach delete a 