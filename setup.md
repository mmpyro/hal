hal config security ui edit --override-base-url http://35.246.235.45
hal config security api edit --override-base-url http://35.246.235.45/spin-gate
hal deploy apply


apiVersion: v1
kind: Service
metadata:
  labels:
    app: spin
    cluster: spin-deck
  name: spin-deck-lb
  namespace: spinnaker
spec:
  ports:
  - port: 9000
    protocol: TCP
    targetPort: 9000
  selector:
    app: spin
    cluster: spin-deck
  sessionAffinity: None
  type: LoadBalancer

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: spin
    cluster: spin-gate
  name: spin-gate-lb
  namespace: spinnaker
spec:
  ports:
  - port: 8084
    protocol: TCP
    targetPort: 8084
  selector:
    app: spin
    cluster: spin-gate
  sessionAffinity: None
  type: LoadBalancer