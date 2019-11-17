import json

def get_json_service(service):

    owners = list()
    for o in service.owner:
        owners.append(o.get_dict());

    clients = list()
    for c in service.client:
        clients.append(c.get_dict())

    s = service.get_dict()
    s["owners"] = owners
    s["clients"] = clients

    return json.dumps(s)

def get_json_owner(owner):

    domains = list()
    for d in owner.domain:
        domains.append(d.get_dict())

    o = owner.get_dict()
    o["domains"] = domains

    return json.dumps(o)

def get_json_client(client):

    reservations = list()
    for r in client.reservation:
        reservations.append(r.get_dict())

    c = client.get_dict()
    c["reservations"] = reservations

    return json.dumps(c)

def get_json_domain(domain):

    elements = list()
    for e in domain.element:
        elements.append(e.get_dict())

    d = domain.get_dict()
    d["elements"] = elements

    return json.dumps(d)
