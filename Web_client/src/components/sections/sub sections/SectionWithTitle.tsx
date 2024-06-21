import React, { ReactNode } from 'react';
import './SectionWithTitle.scss';

interface SectionWithTitleProps {
  title: string;
  children: ReactNode;
}

const SectionWithTitle: React.FC<SectionWithTitleProps> = ({ title, children }) => {
  return (
    <div className="section-with-title">
      <h1 className="section-with-title__header">{title}</h1>
      <div className="section-with-title__content">
        {children}
      </div>
    </div>
  );
}

export default SectionWithTitle;
