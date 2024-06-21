export type BasketState = {
  treasure: ReturnType<typeof BasketReducer>
}

interface IAction {
  type: string
  payload: unknown
}

export interface IBasketState {
  productId: number
  title: string
  price: number
  quantity: number
}

const initialState: IBasketState = {
  productId: 0,
  title: '',
  price: 0,
  quantity: 0,
}

const BasketReducer = (state = initialState, action: IAction) => {
  switch (action.type) {
    default:
      return state
  }
}

export default BasketReducer
