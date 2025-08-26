from models.base import Base
from sqlalchemy import INT, TEXT, VARCHAR, Column, LargeBinary
from sqlalchemy.orm import relationship

class User(Base):
    __tablename__ = 'users'
    id = Column(TEXT, primary_key=True, index=True)
    name= Column(VARCHAR(100))
    email= Column(VARCHAR(100), unique=True)
    password=Column(LargeBinary)

    favorites = relationship('Favorite',back_populates='user')